From: Hannes Reinecke <hare@suse.de>
Subject: Re: [scsi:for-next 200/200] drivers/scsi/scsi_sysfs.c:778: warning:
 comparison is always false due to limited range of data type
Date: Thu, 20 Mar 2014 08:18:26 +0100
Message-ID: <532A9642.5080104@suse.de>
References: <532a7339.vUDcmz4ftHlpah9V%fengguang.wu@intel.com> <1395292032.2185.81.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaCTHS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 03:18:29 -0400
In-Reply-To: <1395292032.2185.81.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/20/2014 06:07 AM, James Bottomley wrote:
> [correct cc to linux-scsi added]
> On Thu, 2014-03-20 at 12:48 +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git =
for-next
>> head:   c6b7d7a684ef39be73f06c14aca4aadad77f42dc
>> commit: c6b7d7a684ef39be73f06c14aca4aadad77f42dc [200/200] [SCSI] In=
validate VPD page data
>> config: make ARCH=3Davr32 atstk1002_defconfig
>>
>> All warnings:
>>
>>    drivers/scsi/scsi_sysfs.c: In function 'show_vpd_pg83':
>>>> drivers/scsi/scsi_sysfs.c:778: warning: comparison is always false=
 due to limited range of data type
>>    drivers/scsi/scsi_sysfs.c: In function 'show_vpd_pg80':
>>>> drivers/scsi/scsi_sysfs.c:779: warning: comparison is always false=
 due to limited range of data type
>>
>> vim +778 drivers/scsi/scsi_sysfs.c
>>
>> beba1fc0 Hannes Reinecke 2014-03-15  772  static struct bin_attribut=
e dev_attr_vpd_##_page =3D {		\
>> beba1fc0 Hannes Reinecke 2014-03-15  773  	.attr =3D	{.name =3D __st=
ringify(vpd_##_page), .mode =3D S_IRUGO },	\
>> beba1fc0 Hannes Reinecke 2014-03-15  774  	.size =3D 0,							\
>> beba1fc0 Hannes Reinecke 2014-03-15  775  	.read =3D show_vpd_##_pag=
e,					\
>> beba1fc0 Hannes Reinecke 2014-03-15  776  };
>> beba1fc0 Hannes Reinecke 2014-03-15  777 =20
>> beba1fc0 Hannes Reinecke 2014-03-15 @778  sdev_vpd_pg_attr(pg83);
>> b6159c63 Hannes Reinecke 2014-03-15 @779  sdev_vpd_pg_attr(pg80);
>> beba1fc0 Hannes Reinecke 2014-03-15  780 =20
>> ^1da177e Linus Torvalds  2005-04-16  781  static ssize_t
>> beba1fc0 Hannes Reinecke 2014-03-15  782  show_iostat_counterbits(st=
ruct device *dev, struct device_attribute *attr,
>>
>> :::::: The code at line 778 was first introduced by commit
>> :::::: beba1fc005a56a0597d01d3f381e533427856f5d [SCSI] Add EVPD page=
 0x83 to sysfs
>>
>> :::::: TO: Hannes Reinecke <hare@suse.de>
>> :::::: CC: James Bottomley <JBottomley@Parallels.com>
>=20
> Actually, it's not just this that's a problem.  Since the _len variab=
les
> are unsigned chars, they're bogus in more ways than having errors put
> into them because the lengths of the pages can go over 255 as well.
>=20
> Bumping them up to int should fix this.  However, the way we go about
> getting the vpd pages looks wrong.  You should reset vpd_len back to =
the
> intial value (255) after obtaining each page, shouldn't you, in order=
 to
> avoid potentially wasting buffer space (unless we're assuming the pag=
es
> always get larger)?
>=20
Hmm. In principle, yes. However in practice VPD page 0x83 tends to
be the largest of them, so we'd only modifying the page length for
that. And then it doesn't matter.

But yeah, I'll be fixing it up.

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
