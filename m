From: Frederic TEMPORELLI <frederic.temporelli@bull.net>
Subject: Re: proc_name in sysfs
Date: Thu, 07 Apr 2005 08:35:16 +0200
Message-ID: <4254D4A4.1000307@bull.net>
References: <4253CA94.8000500@bull.net> <20050406183614.GA25370@us.ibm.com> <4254877B.4020607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:11479 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S261418AbVDGGf1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2005 02:35:27 -0400
In-Reply-To: <4254877B.4020607@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net, Patrick Mansfield <patmans@us.ibm.com>

Hi,


Sorry, no such "driver" directory in /sys/class/scsi_host/hostX/
(checked: Emulex "lpfc" 8.0.24 and LSI "mptscsih" 3.01.18)

note: there's also a "proc_name" interface for LSI "mtpscsih", located =
in=20
/sys/class/scsi_host/hostX/, which is reporting "mptscsih" string.

Any other ideas ?

Best regards.


Douglas Gilbert a =E9crit :
> Patrick Mansfield wrote:
>=20
>> On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote:
>>
>>
>>> 2/ now, how can we get the adapter module name from sysfs ?
>>
>>
>>
>> Why do you need it?
>>
>> Anyway, try lsscsi, it walks the sysfs tree:
>>
>> [elm3b79 patman]$ lsscsi  -H
>> [0]    qla1280
>> [1]    qla1280
>> [2]    qla2xxx
>> [3]    qla2xxx
>>
>> Or, script it:
>>
>> [elm3b79 tmp]$ more xx.sh
>> #! /bin/sh
>>
>> hdir=3D/sys/class/scsi_host
>>
>> for i in ${hdir}/host*
>> do
>>         host_dir=3D$(cd ${i}/device;/bin/pwd)
>>         driver_dir=3D$(cd ${host_dir}/../driver;/bin/pwd)
>>         module=3D$(basename ${driver_dir})
>>         # echo ${i} is in: ${host_dir}
>>         echo "${i} module (driver) is: ${module}"
>> done
>>
>> [elm3b79 tmp]$ sh ./xx.sh
>> /sys/class/scsi_host/host0 module (driver) is: qla1280
>> /sys/class/scsi_host/host1 module (driver) is: qla1280
>> /sys/class/scsi_host/host2 module (driver) is: qla2300
>> /sys/class/scsi_host/host3 module (driver) is: qla2300
>=20
>=20
> Patrick,
> lsscsi currently uses proc_name so it needs to be
> changed to use the above logic (if LLDs are going
> to stop populating proc_name).
>=20
> It has been suggested that I extend lsscsi to show
> transport info (as seen from the HBA) found in the
> various *_transport directories in sysfs.
>=20
> Also I have been thinking about ways to list less
> tha all scsi devices. For example: "lsscsi 1:0:3:0"
> to look at one device and "lsscsi 1:-" for all scsi
> devices hanging off host1. I'm not sure whether
> "lsscsi /dev/sda" is a good idea. Any suggestions?
>=20
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
=46rederic TEMPORELLI
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
