From: Laurence Oberman <loberman@redhat.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 4 Feb 2016 14:25:04 -0500 (EST)
Message-ID: <412135332.11533655.1454613904617.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net> <alpine.LSU.2.11.1601291915010.22105@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net> <alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB445262D4@G9W0766.americas.hpqcorp.net> <DA4D459C-6D64-4028-8D8D-6F266C77E036@kolumbus.fi> <56B393DA.2050307@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:51097 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcBDTZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 14:25:19 -0500
In-Reply-To: <56B393DA.2050307@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>, Shane M Seymour <shane.seymour@hpe.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, linux-scsi@vger.kernel.org


Kai's latest patch passes all my tests on the DAT DSS drive
=46ails on the older LTO3 as it should. (un-partionable)
I don't have the new LTO5 yet, arrives end of week I am told.

Testing log
-----------
[root@srp-server ~]# uname -a
Linux srp-server 4.4.0 #1 SMP Thu Jan 28 15:06:45 EST 2016 x86_64 x86_6=
4 x86_64 GNU/Linux

Storage Changer /dev/sg3:1 Drives, 6 Slots ( 0 Import/Export )
Data Transfer Element 0:Full (Storage Element 2 Loaded)
      Storage Element 1:Full
      Storage Element 2:Empty
      Storage Element 3:Full
      Storage Element 4:Full
      Storage Element 5:Full
      Storage Element 6:Empty

[root@srp-server home]# mtx -f /dev/sg3 unload 2 0
Unloading drive 0 into Storage Element 2...done

[root@srp-server home]# mtx -f /dev/sg3 load 3 0
Loading media from Storage Element 3 into drive 0...done

[root@srp-server home]# sg_map -st -i
/dev/sg2  /dev/nst0  HP        DAT72X6           B409
/dev/sg3  HP        DAT72X6           B409

[root@srp-server home]# mt -f /dev/st0 stsetoption can-partitions

[root@srp-server home]# mt -f /dev/st0 mkpartition 10000

Tape screen shows Format

Completed with no errors and I can set to a specific partition

=46eb 04 13:42:27 srp-server kernel: st: Unloaded.
=46eb 04 13:43:57 srp-server kernel: st: Version 20160203, fixed bufsiz=
e 32768, s/g segs 256
=46eb 04 13:43:57 srp-server kernel: st: Debugging enabled debug_flag =3D=
 1
=46eb 04 13:43:57 srp-server kernel: st 6:0:1:0: Attached scsi tape st0
=46eb 04 13:43:57 srp-server kernel: st 6:0:1:0: st0: try direct i/o: y=
es (alignment 4 B)

=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Block limits 1 -=
 16777215 bytes.
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Mode sense. Leng=
th 11, medium 0, WBS 10, BLL 8
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Density 47, tape=
 length: 0, drv buffer: 1
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Block size: 0, b=
uffer size: 4096 (1 blocks).
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Updating partiti=
on number in status.
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Got tape pos. bl=
k 0 part 0.
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Mode 0 options: =
buffer writes: 1, async writes: 1, read ahead: 1
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0]     can bsr: 1, =
two FMs: 0, fast mteom: 0, auto lock: 0,
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0]     defs for wr:=
 0, no block limits: 0, partitions: 1, s2 log: 0
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0]     sysv: 0 nowa=
it: 0 sili: 0 nowait_filemark: 0
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0]     debugging: 1
=46eb 04 13:48:30 srp-server kernel: st 6:0:1:0: [st0] Rewinding tape.

=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Block limits 1 -=
 16777215 bytes.
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Mode sense. Leng=
th 11, medium 0, WBS 10, BLL 8
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Density 47, tape=
 length: 0, drv buffer: 1
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Block size: 0, b=
uffer size: 4096 (1 blocks).
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Loading tape.
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Error: 8000002, =
cmd: 0 0 0 0 0 0
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Sense Key : Unit=
 Attention [current]
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Add. Sense: Not =
ready to ready change, medium may have changed
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Block limits 1 -=
 16777215 bytes.
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Mode sense. Leng=
th 11, medium 0, WBS 10, BLL 8
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Density 47, tape=
 length: 0, drv buffer: 1
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Block size: 0, b=
uffer size: 4096 (1 blocks).
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Partition page l=
ength is 10 bytes.
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] PP: max 1, add 0=
, xdp 0, psum 02, pofmetc 0, rec 03, units 00, sizes: 0 65535
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] MP: 11 08 01 00 =
10 03 00 00 00 00 ff ff
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] psd_cnt 1, max.p=
arts 1, nbr_parts 0
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Formatting tape =
with two partitions (1 =3D 10000 MB).
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] Sent partition p=
age length is 10 bytes. needs_format: 0
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] PP: max 1, add 1=
, xdp 1, psum 02, pofmetc 0, rec 03, units 00, sizes: 10000 65535
=46eb 04 13:48:42 srp-server kernel: st 6:0:1:0: [st0] MP: 11 08 01 01 =
30 03 00 00 27 10 ff ff


Tested-by: Laurence Oberman <loberman@redhat.com>

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Douglas Gilbert" <dgilbert@interlog.com>
To: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>, "Shane M=
 Seymour" <shane.seymour@hpe.com>
Cc: "Laurence Oberman" <loberman@redhat.com>, "Emmanuel Florac" <eflora=
c@intellique.com>, "Laurence Oberman" <oberman.l@gmail.com>, linux-scsi=
@vger.kernel.org
Sent: Thursday, February 4, 2016 1:09:30 PM
Subject: Re: What partition should the MTMKPART argument specify? Was: =
Re: st driver doesn't seem to grok LTO partitioning

Hi,
With a HP Ultrium 3000 tape drive (LTO-5) and a HP C7975A
tape cartridge (LTO-5 and partition capable) and mt as
patched by Shane:

# lsscsi -g
[1:0:0:0]  disk    ATA    ST3320620AS      K     /dev/sda   /dev/sg0
[6:0:0:0]  tape    HP     Ultrium 5-SCSI   Z64D  /dev/st0   /dev/sg1

# sg_read_attr -s 3 /dev/sg1
Partition number list:
   First partition number: 0
   Number of partitions available: 1

# mt -f /dev/st0 stsetoption debug
# mt -f /dev/st0 stsetoption can-partitions
# mt -f /dev/st0 mkpartition 10000

The following was cut and pasted from /var/log/messages

st 6:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[st0] Density 58, tape length: 0, drv buffer: 1
[st0] Block size: 0, buffer size: 4096 (1 blocks).
[st0] Updating partition number in status.
[st0] Got tape pos. blk 0 part 0.
[st0] Loading tape.
[st0] Block limits 1 - 16777215 bytes.
[st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[st0] Density 58, tape length: 0, drv buffer: 1
[st0] Block size: 0, buffer size: 4096 (1 blocks).
[st0] Partition page length is 12 bytes.
[st0] PP: max 1, add 0, xdp 1, psum 03, pofmetc 4, rec 03, units 09, si=
zes: 1529 0
[st0] MP: 11 0a 01 00 3c 03 09 00 05 f9 00 00
[st0] psd_cnt 2, max.parts 1, nbr_parts 0
[st0] Formatting tape with two partitions (1 =3D 10000 MB).
[st0] Sent partition page length is 12 bytes. needs_format: 1
[st0] PP: max 1, add 1, xdp 1, psum 03, pofmetc 4, rec 03, units 09, si=
zes: 65535 10
[st0] MP: 11 0a 01 01 3c 03 09 00 ff ff 00 0a
[st0] Sending FORMAT MEDIUM
[st0] Rewinding tape.

# sg_read_attr -s 3 /dev/sg1
Partition number list:
   First partition number: 0
   Number of partitions available: 2

Looks good.

Tested-by: Douglas Gilbert <dgilbert@interlog.com>


On 16-02-04 12:54 PM, "Kai M=C3=A4kisara (Kolumbus)" wrote:
>
>> On 4.2.2016, at 3.43, Seymour, Shane M <shane.seymour@hpe.com> wrote=
:
>>
>> Hi Kai,
>>
>> Tested with patched kernel 4.5.0-rc2-next-20160202+. It's looking go=
od everything partition related passed with DDS5 and LTO6. You can defi=
nitely add me as a tested-by. I did find one issue below but it's not r=
elated to the partitioning changes.
>>
> Thanks for testing. It would be interesting to get confirmation from =
a LTO-5 user that partitioning
> works. Even without that I will make the final patch within a few day=
s (remove some debugging
> and update the documentation).
>
> ...
>> I did find one issue in testing unrelated to the changes, the tell o=
ption didn't work with my LTO-6 drive:
>>
>> # ./mt -f /dev/st0 tell
>> /dev/st0: Input/output error
>>
>> [ 2045.974642] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
>> [ 2045.975221] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WB=
S 10, BLL 8
>> [ 2045.975224] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buf=
fer: 1
>> [ 2045.975226] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1=
 blocks).
>> [ 2045.975718] st 3:0:0:0: [st0] Error: 8000002, cmd: 34 1 0 0 0 0
>> [ 2045.975723] st 3:0:0:0: [st0] Sense Key : Illegal Request [curren=
t]
>> [ 2045.975726] st 3:0:0:0: [st0] Add. Sense: Invalid field in cdb
>> [ 2045.975729] st 3:0:0:0: [st0]  Can't read tape position.
>> [ 2045.975857] st 3:0:0:0: [st0] Rewinding tape.
>>
>> I believe that in get_location() we're doing this:
>>
>> static int get_location(struct scsi_tape *STp, unsigned int *block, =
int *partition,
>>                         int logical)
>> {
>>         int result;
>>         unsigned char scmd[MAX_COMMAND_SIZE];
>>         struct st_request *SRpnt;
>>
>>         if (STp->ready !=3D ST_READY)
>>                 return (-EIO);
>>
>>         memset(scmd, 0, MAX_COMMAND_SIZE);
>>         if ((STp->device)->scsi_level < SCSI_2) {
>>                 scmd[0] =3D QFA_REQUEST_BLOCK;
>>                 scmd[4] =3D 3;
>>         } else {
>>                 scmd[0] =3D READ_POSITION;
>>                 if (!logical && !STp->scsi2_logical)
>>                         scmd[1] =3D 1; <<<<<<<<<<<<<<
>>         }
>>
>> When called from the ioctl that the tell option uses the variable lo=
gical is passed in as 0 (from what I could see everything else sets it =
to 1). For a READ_POSITION the drive I'm using only supports 0, 6, or 8=
 in the service action field of the second byte:
>>
> I think you have not set the scsi2_logical option bit with mt or stin=
it or some other tool.
> The default of device-specific addresses is a historical mistake but =
we have to live with
> it. I don=E2=80=99t see this as a big problem because any user of cur=
rent drives should enable
> some driver options anyway.
>
> Thanks,
> Kai
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
