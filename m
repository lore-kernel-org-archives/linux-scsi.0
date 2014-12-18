From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/2] target: Fixes for AllRegistrants reservation handling
Date: Thu, 18 Dec 2014 11:53:47 -0500
Message-ID: <5493069B.3060701@interlog.com>
References: <20141218145401.GD2476@iliastsi-m.arr>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20141218145401.GD2476@iliastsi-m.arr>
Sender: target-devel-owner@vger.kernel.org
To: Ilias Tsitsimpis <iliastsi@arrikto.com>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Alexander Motin <mav@FreeBSD.org>
List-Id: linux-scsi@vger.kernel.org

On 14-12-18 09:54 AM, Ilias Tsitsimpis wrote:
> On Tue, Dec 16, 2014 at 12:09AM, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> Hi all,
>>
>> This series addresses two issues raised recently by Ilias wrt
>> AllRegistrants reservation handling in target code that does not
>> adhere to SPC-4 specification requirements.
>>
>> This first is a informational change to PR-IN READ_FULL_STATUS,
>> that when an AllRegistrants reservation is in place, all active
>> registrations should be setting R_HOLDER=1 within their respective
>> descriptors.
>>
>> The second is a functional change to PR-OUT REGISTER w/ SARK=0
>> operation, to avoid dropping the AllRegistrants reservation until
>> the last registered I_T nexus has been released.  It also ensures
>> that the correct reservation type + scope is retained when the
>> new reservation is set within __core_scsi3_complete_pro_release()
>> for this AllRegistrants special case.
>>
>> Also, thanks to James for the extra SPC-4 clarifications.
>>
>> Please review.
>
> Hi Nicholas,
>
> Thanks for the quick fix. These patches address the two issues that I
> raised in my previous email but they don't seem to fix all the problems
> with AllRegistrants reservation handling in target code. Please see my
> example below.
>
> I have set up an iSCSI target, using the Linux SCSI Target
> implementation with your patches applied, and I am connecting to it from
> two different nodes using the open-iscsi project.
>
>      root@node1:~# sg_inq /dev/sdc
>      standard INQUIRY:
>        PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>        [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>        SCCS=1  ACC=0  TPGS=3  3PC=1  Protect=0  BQue=0
>        EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>        [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>          length=36 (0x24)   Peripheral device type: disk
>       Vendor identification: LIO-ORG
>       Product identification: FILEIO
>       Product revision level: 4.0
>       Unit serial number: 853ea439-7fcf-4aaa-9de2-1399e06b45be

Here is an alternate open source implementation of an
iSCSI target/server:

root@node1:~# sg_inq /dev/sdc
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x06  [SPC-4]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=1  3PC=1  Protect=0  [BQue=0]
   EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=96 (0x60)   Peripheral device type: disk
  Vendor identification: FreeBSD
  Product identification: iSCSI Disk
  Product revision level: 0123
  Unit serial number: 0015f2d0d8b600

>      root@node2:~# sg_inq /dev/sdc
>      standard INQUIRY:
>        PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>        [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>        SCCS=1  ACC=0  TPGS=3  3PC=1  Protect=0  BQue=0
>        EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>        [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>          length=36 (0x24)   Peripheral device type: disk
>       Vendor identification: LIO-ORG
>       Product identification: FILEIO
>       Product revision level: 4.0
>       Unit serial number: 853ea439-7fcf-4aaa-9de2-1399e06b45be

root@node2:~# sg_inq /dev/sdb
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x06  [SPC-4]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=1  3PC=1  Protect=0  [BQue=0]
   EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=96 (0x60)   Peripheral device type: disk
  Vendor identification: FreeBSD
  Product identification: iSCSI Disk
  Product revision level: 0123
  Unit serial number: 0015f2d0d8b600


Now playing along with the same test sequence and noting when
there are significant differences.

> I register both of the I_T nexuses with the target.
>
>      root@node1:~# sg_persist --out --register --param-sark 0x1 /dev/sdc
>
>      root@node2:~# sg_persist --out --register --param-sark 0x2 /dev/sdc
>
>      root@node1:~# sg_persist --in --read-full-status /dev/sdc
>        LIO-ORG   FILEIO            4.0
>        Peripheral device type: disk
>        PR generation=0x17
>          Key=0x1
>            All target ports bit clear
>            Relative port address: 0x5
>            not reservation holder
>            Transport Id of initiator:
>              iSCSI name and session id: iqn.1993-08.org.debian:01:node1
>          Key=0x2
>            All target ports bit clear
>            Relative port address: 0x5
>            not reservation holder
>            Transport Id of initiator:
>              iSCSI name and session id: iqn.1993-08.org.debian:01:node2
>
> Then I get a persistent reservation with type 'Exclusive Access - All
> Registrants' from node1.
>
>      root@node1:~# sg_persist --out --reserve -T 8 --param-rk 0x1 /dev/sdc
>      root@node1:~# sg_persist --in --read-full-status /dev/sdc
>        LIO-ORG   FILEIO            4.0
>        Peripheral device type: disk
>        PR generation=0x17
>          Key=0x1
>            All target ports bit clear
>            Relative port address: 0x5
>            << Reservation holder >>
>            scope: LU_SCOPE,  type: Exclusive Access, all registrants
>            Transport Id of initiator:
>              iSCSI name and session id: iqn.1993-08.org.debian:01:node1
>          Key=0x2
>            All target ports bit clear
>            Relative port address: 0x5
>            << Reservation holder >>
>            scope: LU_SCOPE,  type: Exclusive Access, all registrants
>            Transport Id of initiator:
>              iSCSI name and session id: iqn.1993-08.org.debian:01:node2
>
> As you can see both registrants are reported as reservations holders,
> which is the right thing to do.
>
> Now let's try to get a persistent reservation with the same type from
> node2. SPC4r17 (par. 5.7.9 Reserving) states that:
>
>      If the device server receives a PERSISTENT RESERVE OUT command with
>      RESERVE service action where the TYPE field and the SCOPE field
>      contain the same values as the existing type and scope from a
>      persistent reservation holder, it shall not make any change to the
>      existing persistent reservation and shall complete the command with
>      GOOD status.
>
> Node2 *is* a persistent reservation holder based on the wording of
> SPC4r17 (par. 5.7.10 Persistent reservation holder).
> But instead:
>
>      root@node2:~# sg_persist --out --reserve -T 8 --param-rk 0x2 /dev/sdc
>        LIO-ORG   FILEIO            4.0
>        Peripheral device type: disk
>      persistent reserve out: scsi status: Reservation Conflict
>      PR out: command failed
>
> and on the target machine I get:
>
>      [95713.681066] SPC-3 PR: Attempted RESERVE from [iSCSI]:
>      iqn.1993-08.org.debian:01:node2 while reservation already held by
>      [iSCSI]: iqn.1993-08.org.debian:01:node1, returning
>      RESERVATION_CONFLICT

With FreeNAS as the iSCSI target (server), the above command on
node2 succeeds.

> If I try the same from node1, the target completes the command with GOOD
> status.

And back on node1 I see:

root@node1:~# sg_persist --out --reserve -T 8 --param-rk 0x2 /dev/sdc
   FreeBSD   iSCSI Disk        0123
   Peripheral device type: disk
PR out (Reserve): Reservation conflict

which I am guessing is what was expected.

> It is clear that the target code still considers node1 as the (only)
> reservation holder and only *reports* node2 as being a reservation
> holder.
>
> I believe we should fix the above errors by changing the
> 'pr_res_holder' inside the 't10_reservation' struct to be a list of
> holders rather than trying to handle this implicitly. Having a single
> holder in the code seems prone to more errors similar to this one.


I think Alexander Motin has done a pretty impressive
job over at FreeBSD in the SCSI target area. FreeNAS
(9.3 recently released) is a convenient packaging for
turning a box (or just an old disk in my case) into an
iSCSI target.


FreeNAS's iSCSI target also implements ODX which is one
reason why I have been looking at it (hint to NAB). With
ODX it does cut one significant corner in only supporting
"access upon reference" RODs. Its ODX implementation found
several bugs and holes in my ddpt ODX client code. Perhaps
NAB might check how FreeBSD's code handles the AllRegistrants
reservation handling case.

Doug Gilbert
