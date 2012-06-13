From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC] Filtering SG_IO commands using cgroups
Date: Wed, 13 Jun 2012 12:02:50 +0200
Message-ID: <4FD8654A.1090006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <JBottomley@parallels.com>, Libvirt <libvir-list@redhat.com>
List-Id: linux-scsi@vger.kernel.org

While we wait for Al's answer, it seems to me that filtering CDBs with cgroups is a
pretty natural extension of filtering devices with cgroups.  So here is a possible
specification for such a cgroup.

[CCing the libvirt mailing list since they could be one of the first clients]

Paolo




SG_IO Filter Controller ("cdb")

1. Description

The cdb cgroup implement a way to filter allowed SCSI commands according
to one or more Berkeley Packet Filter programs associated to the cgroup
and its parents.  BPF programs have access to the CDB and various
ancillary data about the device.

To be allowed, a command must be allowed by at least one program for each
cgroup from the current task's to the root.  In addition, as a general
rule it must pass the regular check on privileged commands that is done
even without cgroups.  Groups with no programs are handled specially so
that the default configuration is the same as without cgroups.

Privileged tasks may install programs that bypass the usual check on
"dangerous" SCSI commands. Non-privileged tasks in the same cgroup will
also be able to bypass the check, but they may not widen their privileged
abilities beyond what the cgroup already has.

Administrators can replace the current entries, or add new ones.  Replacing
the entries in a cgroup will never affect those that are inherited from
the parent.  However when a parent cgroup is changed, the new filters
will also apply to the children.


2. Operation

The BPF program can return one of the following values:

* 0: the CDB is denied.  Another program in the cgroup will be tried,
  or the SG_IO ioctl will return with EPERM if there are none.

* 1: the CDB is allowed; it should be subject to the bitmap that is
  used in the absence of cgroups.

* 2: the CDB is allowed, and the generic filter may be bypassed.

Programs that return 2 or the value of the accumulator are called
privileged in the remainder of this document.


BPF programs used with the cdb cgroup have access to the following
ancillary values:

* ANC_MAJOR (45): the major number of the device

* ANC_MINOR (46): the minor number of the device

* ANC_BLOCK (47): 1 if the device is a block device, 0 if it is a
  character device

* ANC_PART (48): the partition number of the device; 0 if it is a
  character device

* ANC_MODE (49): one of O_RDONLY/O_WRONLY/O_RDWR depending on how
  the file was opened.

* ANC_RAWIO (50): 1 if the current process has CAP_SYS_RAWIO, 0
  otherwise.


Evaluation goes through all filters in each cgroup and picks the most
permissive (largest) value.  It also goes through all cgroups from the
current task's up to the root, and executes filters in there; but here
it picks the most restrictive value.  In other words the result from
multiple filters is "ORed", while the result from multiple cgroups
is "ANDed".

Cgroups with no filters are skipped, with one exception: if the current
task is in a cgroup with no filters, it will behave as if it had this
special filter:

    pseudocode:                          |         BPF:
        if capable(CAP_SYS_RAWIO)        |         ANC RAWIO
            return 2                     |         ADD #1
        else                             |         RET A
            return 1                     |

This has two effects:

1) when a non-privileged task is moved from a privileged cgroup to a
new cgroup, it will be subject to the generic filter;

2) when a task is in the root cgroup, and the root cgroup has no
filters, it behaves as if the cdb cgroup did not exist at all.

This maps to the following algorithm:

    privileged = YES
    allowed = YES
    for each cgroup C from the current task cdb cgroup to the root
        if no filters in C
            if C is the current task cdb cgroup
                privileged &= capable(CAP_SYS_RAWIO)
            continue

        privileged_this_cgroup = NO
        allowed_this_cgroup = NO
        for each filter F in C
            ret = run_filter(F, cdb)
            if ret != 0 then
                allowed_this_cgroup = YES
            if ret == 2 then
                privileged_this_cgroup = YES

        privileged &= privileged_this_cgroup
        allowed &= allowed_this_cgroup

    if !allowed then
        return EPERM

    if !privileged then
        test CDB against bitmap

    execute CDB

(Of course some short-circuiting is possible).


3. User Interface

The cgroup provides three files:

* cdb.filter: entries are modified using this file.  Entries are
added if the file was opened with O_APPEND, otherwise they are replaced.
Opening the file with O_TRUNC immediately removes all filters.  These
rules are chosen so that shell redirections (including ":>cdb.filter")
will do the right thing.

Adding or replacing programs requires CAP_SYS_ADMIN.   Adding
privileged programs *in addition* requires CAP_SYS_RAWIO.

An entry is represented by multiple occurrences of the following
structure, which must all be written with a single system call:

        struct bpf_insn {
                u16 code;
                u8  jt;
                u8  jf;
                u32 k;
        };

in the native endianness of the running architecture.  A zero-length
write will do nothing if the file was opened with O_APPEND, and
remove all entries if it wasn't.

* cdb.list: entries are retrieved using this file.  All filters
are preceded by a 32-bit value counting the number of bpf_insn
structs in the program, and concatenated.

* cdb.priv: returns 1 if the cgroup is privileged (has at least one
privileged filter).  This is true if at least one filter includes
a "RET #2" or "RET A" instruction.


4. Security

Filters that include the "RET A" or "RET #2" instructions can only
be added by a task that has CAP_SYS_RAWIO; thus only tasks with
CAP_SYS_RAWIO, who could bypass the bitmap themselves, can also
let other processes do so.  Such cgroups are marked as privileged;
CAP_SYS_RAWIO is required to attach a process to a privileged cgroup.
The privileged status is visible in the "cdb.priv" file.

While such filters let non-privileged processes and their children
bypass the bitmap, this only holds as long as the non-privileged
process does none of the following operations (which by themselves
require CAP_SYS_ADMIN):

* replace all filters from the cgroup

* create a new sub-cgroup and move itself to it

Because in either case, the empty cgroup will behave as if it
had "RET #1".

In addition, new filters added to the cgroup will never widen the
privileged abilities of the process, because filters with "RET #2"
or "RET A" will not be allowed.


5. Examples of filters

5.1. Persistent reservations

This filter lets a program use persistent reservations, plus any
other command that is allowed without CAP_SYS_RAWIO:

          LD_B 0                        ; A = cdb[0]
          JGT  #0x5f, Lpass, 1f         ; pass if > PR OUT
1:        JGE  #0x5e, Lpr, Lpass        ; pass if < PR IN
Lpass:    RET  #1                       ; go to bitmap check
Lpr:      RET  #2                       ; bypass bitmap check

A program could put itself in a new cgroup, add this filter and then
drop CAP_SYS_RAWIO/CAP_SYS_ADMIN.


5.2. Arbitrary bitmap

This filter could be used as a template to convert a 256-bit bitmap
to a BPF program.

          LD_B 0
          AND  #31
          TAX                             ; X = cdb[0] & 31
          LD   #1
          LSH  X
          TAX                             ; X = 1 << (cdb[0] & 31)
          LD_B 0                          ; A = cdb[0]

          JSET #128, L1xx, L0xx           ; Decode bit 7 of the opcode
L0xx:     JSET #64, L01x, L00x            ; Decode bit 6
L1xx:     JSET #64, L11x, L10x

L00x:     JSET #32, L001, L000            ; Decode bit 5
L01x:     JSET #32, L011, L010
L10x:     JSET #32, L101, L100
L11x:     JSET #32, L111, L110

L000:     TXA; JSET #..., Lpass, Lfail    ; fill in bitmap values here
L001:     TXA; JSET #..., Lpass, Lfail
L010:     TXA; JSET #..., Lpass, Lfail
L011:     TXA; JSET #..., Lpass, Lfail
L100:     TXA; JSET #..., Lpass, Lfail
L101:     TXA; JSET #..., Lpass, Lfail
L110:     TXA; JSET #..., Lpass, Lfail
L111:     TXA; JSET #..., Lpass, Lfail

Lpass:    RET #1                          ; could also be RET #2
Lfail:    RET #0
