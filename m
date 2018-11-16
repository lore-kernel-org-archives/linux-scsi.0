From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] block: add back command filter modification via
 sysfs
Date: Thu, 15 Nov 2018 21:46:04 -0800
Message-ID: <1542347164.100259.32.camel@acm.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
         <1541867733-7836-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541867733-7836-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2018-11-10 at 17:35 +-0100, Paolo Bonzini wrote:
+AD4 +-sgio+AF8-read+AF8-filter (RW)
+AD4 +----------------------
+AD4 +-When read, this file will display a list of SCSI commands (i.e. values of
+AD4 +-the first byte of a CDB) that are always available for unprivileged users
+AD4 +-via /dev/bsg, /dev/sgNN, or ioctls such as SG+AF8-IO and CDROM+AF8-SEND+AF8-PACKET.
+AD4 +-When written, the list of commands will be modified.  The default filter
+AD4 +-can be restored by writing +ACI-default+ACI to the file+ADs otherwise the input should
+AD4 +-be a list of byte values or ranges such as +ACI-0x00-0xff+ACI.  In the latter case,
+AD4 +-instead of replacing the filter completely you can add to the commands,
+AD4 +-by writing a string that begins with '+-', or remove them by writing a
+AD4 +-string that begins with '-'.
+AD4 +-
+AD4 +-sgio+AF8-write+AF8-filter (RW)
+AD4 +-----------------------
+AD4 +-When read, this file will display a list of SCSI commands (i.e. values of
+AD4 +-the first byte of a CDB) that are available for unprivileged users
+AD4 +-when the block device is open for writing.  Writing to this file behaves
+AD4 +-as for sgio+AF8-read+AF8-filter.

This seems like an unfortunate API choice to me. Let's have a look at the
following SBC commands:
+ACo READ(6)+ADs  opcode 08h.
+ACo READ(10)+ADs opcode 28h.
+ACo READ(12)+ADs opcode A8h.
+ACo READ(16)+ADs opcode 88h.
+ACo READ(32)+ADs opcode 7fh+ADs service action 0009h.

I do not know any application for which it would be useful to allow some but
not all of these commands. With the proposed interface however users will
have to examine all SCSI opcodes and for each opcode they will have to decide
whether or not it should be allowed. Additionally, for opcodes like 7fh that
represent multiple commands, users will have to decide whether they want to
allow all these commands or none. That's why I think that filtering SCSI
commands based on their CDB is an unfortunate choice. Would it be sufficient
for the use cases you are looking at to group SCSI commands as follows and to
enable/disable these commands per group:
+ACo SCSI command that read information from the medium (e.g. READ) or from the
  controller (e.g. READ CAPACITY).
+ACo SCSI commands that modify information on the medium (e.g. WRITE).
+ACo SCSI commands that modify controller settings (e.g. MODE SELECT or SET
  TARGET PORT GROUPS).

Bart.
