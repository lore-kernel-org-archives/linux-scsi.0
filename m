From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re: st
 driver doesn't seem to grok LTO partitioning
Date: Thu, 4 Feb 2016 13:09:30 -0500
Message-ID: <56B393DA.2050307@interlog.com>
References: <20151218170644.24167419@harpe.intellique.com>
 <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
 <20160106170720.61db9e86@harpe.intellique.com>
 <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
 <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net>
 <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
 <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
 <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net>
 <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
 <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601291915010.22105@xnv.znxvfnen.cevingr>
 <DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net>
 <alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr> <DDB9C85B850785
 449757F9 914A034FCB445262D4@G9W0766.americas.hpqcorp.net>
 <DA4D459C-6D64-4028-8D8D-6F266C77E036@kolumbus.fi>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36975 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbcBDSJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 13:09:46 -0500
In-Reply-To: <DA4D459C-6D64-4028-8D8D-6F266C77E036@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?Kai_M=c3=a4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>, "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

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
