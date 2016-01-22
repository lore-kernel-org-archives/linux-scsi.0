From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Fri, 22 Jan 2016 11:17:23 +0100
Message-ID: <56A201B3.6070502@interlog.com>
References: <20151218170644.24167419@harpe.intellique.com>
 <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
 <20160104124626.3112e8c0@harpe.intellique.com>
 <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
 <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
 <20160106161049.34f29973@harpe.intellique.com>
 <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
 <20160106170720.61db9e86@harpe.intellique.com>
 <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39848 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbcAVKRc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 05:17:32 -0500
In-Reply-To: <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>
Cc: Laurence Oberman <oberman.l@gmail.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

Laurence,
Shane Seymour from HP provided this useful link:
   https://docs.oracle.com/cd/E21419_04/en/LTO5_Vol3_E5b/LTO5_Vol3_E5b.=
pdf

That documents the WRITE BUFFER command on pages 228 and 229 used
by HP LTO-5 drives. For sending new firmware it looks like you need
to use MODE 4 or 5. [That description does not look like the work of
an engineer who understands the subject matter :-)].

And it seems like HP implement the REPORT SUPPORTED OPCODES command
which means you can use the sg_opcodes utility. For the WRITE BUFFER
command, that should break out the MODE numbers that the drive
actually supports. For example, this from a SSD:
=2E..
  3b  0  10  Write buffer, combined header and data [or multiple modes]
  3b  2  10  Write buffer, data
  3b  4  10  Write buffer, download microcode and activate
  3b  5  10  Write buffer, download microcode, save, and activate
  3b  6  10  Write buffer, download microcode with offsets and activate
  3b  7  10  Write buffer, download microcode with offsets, save, and a=
ctivate
  3b  a  10  Write buffer, write data to echo buffer
=2E..

Looking back in this thread I see you mention a Quantum Ultrium 5
tape drive; so this HP information may not apply.

Doug Gilbert


On 16-01-14 09:12 PM, Laurence Oberman wrote:
> All attempts to get my drive and changer firmware updated have failed=
=2E
> So I wont be able to add another "tested by" to this thread unless I =
can find another drive.
>
> Even using Doug's method fails to actually update. Seems to suck up t=
he image and then do nothing.
> Lands up in getting hung and needs a full power reset.
>
> The image I have is the correct image.
>
> I dont want to try to many convoluted methods because I dont want to =
brick the changer.
>
> Its the only one I have for doing all the st driver testing here at R=
ed Hat in the GSS team.
>
> Thanks
>
> Laurence Oberman
> Principal Software Maintenance Engineer
> Red Hat Global Support Services
>
> ----- Original Message -----
> From: "Emmanuel Florac" <eflorac@intellique.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Kai Makisara" <Kai.Mak=
isara@kolumbus.fi>, linux-scsi@vger.kernel.org
> Sent: Wednesday, January 6, 2016 11:07:20 AM
> Subject: Re: st driver doesn't seem to grok LTO partitioning
>
> Le Wed, 6 Jan 2016 10:23:34 -0500 (EST)
> Laurence Oberman <loberman@redhat.com> =C3=A9crivait:
>
>> MaxPartitions: 0
>>
>> Drive is working fine,
>>
>> # mt -f /dev/st0 status
>> SCSI 2 tape drive:
>> File number=3D0, block number=3D0, partition=3D0.
>> Tape block size 512 bytes. Density code 0x58 (no translation).
>> Soft error count since last status=3D0
>> General status bits on (41010000):
>>   BOT ONLINE IM_REP_EN
>>
>> This is what I get when I try and partition and I believe this may b=
e
>> a firmware issue for me.
>
> Yes probably, it reports "MaxPartitions 0", should be 1 for an LTO-5
> drive. Weird.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
