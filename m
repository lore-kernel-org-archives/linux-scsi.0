From: Hannes Reinecke <hare@suse.de>
Subject: Re: Kernel crash with unsupported DIF protection type
Date: Tue, 18 Sep 2012 11:35:35 +0200
Message-ID: <50584067.2010505@suse.de>
References: <50583924.90708@suse.de> <50583F32.1010103@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab2IRJfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 05:35:37 -0400
In-Reply-To: <50583F32.1010103@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/18/2012 11:30 AM, Douglas Gilbert wrote:
> On 12-09-18 11:04 AM, Hannes Reinecke wrote:
>> Hi all,
>>
>> I recently got my hands on some weird drives, insisting on having
>> been formatted with protection type 7:
>>
>> # sg_readcap --16 /dev/sdb
>> Read Capacity results:
>>     Protection: prot_en=3D1, p_type=3D6, p_i_exponent=3D0
>>     Logical block provisioning: lbpme=3D0, lbprz=3D0
>>     Last logical block address=3D1758174767 (0x68cb9e2f), Number of
>> logical blocks=3D1758174768
>>     Logical block length=3D512 bytes
>>     Logical blocks per physical block exponent=3D0
>>     Lowest aligned logical block address=3D0
>> Hence:
>>     Device size: 900185481216 bytes, 858483.8 MiB, 900.19 GB
>>
>> (I know. I've already complained.)
>> However, this drive causes a horrible crash:
>>
>> sd 0:0:1:0: [sdb] formatted with unsupported protection type 7.
>> Disabling disk!
>> sd 0:0:1:0: [sdb] 1758174768 512-byte logical blocks: (900
>> GB/838 GiB)
>> sd 0:0:1:0: [sdb]  Result: hostbyte=3DDID_OK
>> driverbyte=3DDRIVER_SENSE
>> sd 0:0:1:0: [sdb]  Sense Key : Medium Error [current]
>> sd 0:0:1:0: [sdb]  Add. Sense: Medium format corrupted
>> sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
>> end_request: I/O error, dev sdb, sector 0
>> Buffer I/O error on device sdb, logical block 0
>>
>> [ tons and tons of I/O errors ]
>>
>> [   15.551689] sd 0:0:1:0: [sdb] Enabling DIX T10-DIF-TYPE1-CRC
>> protection
>> [   15.561353] ------------[ cut here ]------------
>> [   15.569416] kernel BUG at
>> /usr/src/linux-3.0/drivers/scsi/scsi_lib.c:1069!
>>
>> There are several odd things happening here:
>> - It says 'Disabling disk', which _should_ have set the
>>    capacity to '0':
>>
>> drivers/scsi/sd.c:sd_read_protection_type()
>>     if (type > SD_DIF_TYPE3_PROTECTION) {
>>         sd_printk(KERN_ERR, sdkp, "formatted with unsupported "    \
>>               "protection type %u. Disabling disk!\n", type);
>>         sdkp->capacity =3D 0;
>>         return;
>>     }
>>
>> - it enables type 1 protection, which it evidently is not.
>>
>> I've attached a tentative patch, which allows the system to boot.
>> However, I'm not completely happy with that, as the capacity is
>> _still_ updated after revalidation:
>>
>> sd 0:0:1:0: [sdb] formatted with unsupported protection type 7.
>> Disabling disk!
>> sd 0:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
>> sd 0:0:1:0: [sdb] Write Protect is off
>> sd 0:0:1:0: [sdb] Mode Sense: cf 00 10 08
>> sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled,
>> supports DPO and FUA
>> sd 0:0:1:0: [sdb] 1758174768 512-byte logical blocks: (900 GB/838
>> GiB)
>> sd 0:0:1:0: [sdb] Attached SCSI disk
>>
>> Thoughts?
>=20
> The "Medium format corrupted" additional sense qualifier occurs
> (with Seagate disks) when a FORMAT UNIT command is interrupted.
> So maybe, for good measure, that disk also sets the DIF
> protection type to an unsupported value (i.e. 7). So re-doing a
> FORMAT  UNIT may clear that state.
>=20
Yeah, that's what I'm doing now.

Incidentally:

sg_format manpage says:

       Format with type 1 protection:

          sg_format --format --fmtpinfo=3D3 --pfu /dev/sdm

but the '--pfu' option requires an argument.
According to sbc3r23 the command should read:

sg_format --format --fmtpinfo=3D3 --pfu=3D1 /dev/sdm

Correct?

> Obviously the kernel should not crash when faced with such
> a disk.
>=20
Precisely.
Especially the 'Disabling disk' no-op is worrying.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
