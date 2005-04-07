From: Douglas Gilbert <dougg@torque.net>
Subject: Re: proc_name in sysfs
Date: Thu, 07 Apr 2005 18:17:26 +1000
Message-ID: <4254EC96.8070104@torque.net>
References: <4253CA94.8000500@bull.net> <20050406183614.GA25370@us.ibm.com> <4254877B.4020607@torque.net> <4254D4A4.1000307@bull.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:33666 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262251AbVDGIVa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2005 04:21:30 -0400
In-Reply-To: <4254D4A4.1000307@bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@bull.net>
Cc: linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>

=46rederic TEMPORELLI wrote:
> Hi,
>=20
>=20
> Sorry, no such "driver" directory in /sys/class/scsi_host/hostX/
> (checked: Emulex "lpfc" 8.0.24 and LSI "mptscsih" 3.01.18)

I may have missed the point here. Are you talking about
Patrick's shell script? It sort of works for me. Example:

$ ./scan_hosts.sh
/sys/class/scsi_host/host0 module (driver) is: mptbase
/sys/class/scsi_host/host1 module (driver) is: mptbase
/sys/class/scsi_host/host2 module (driver) is: mptbase
/sys/class/scsi_host/host3 module (driver) is: mptbase
/sys/class/scsi_host/host4 module (driver) is: qla2300
/sys/class/scsi_host/host5 module (driver) is: qla2300
$ lsscsi -H
[0]    mptscsih
[1]    mptscsih
[2]    mptscsih
[3]    mptscsih
[4]    qla2xxx
[5]    qla2xxx

Note that the module name and the proc_name are different!
It looks like Patrick's script gives the module name
"closest" to the PCI bus while proc_name gives the
"upper" lower level driver name :-)

BTW "/bin/pwd" gives a different result to "pwd"
in a bash shell just after a symlink has been
followed.

Doug Gilbert

> note: there's also a "proc_name" interface for LSI "mtpscsih", locate=
d=20
> in /sys/class/scsi_host/hostX/, which is reporting "mptscsih" string.
>=20
> Any other ideas ?
>=20
> Best regards.
>=20
>=20
> Douglas Gilbert a =E9crit :
>=20
>> Patrick Mansfield wrote:
>>
>>> On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote=
:
>>>
>>>
>>>> 2/ now, how can we get the adapter module name from sysfs ?
>>>
>>>
>>>
>>>
>>> Why do you need it?
>>>
>>> Anyway, try lsscsi, it walks the sysfs tree:
>>>
>>> [elm3b79 patman]$ lsscsi  -H
>>> [0]    qla1280
>>> [1]    qla1280
>>> [2]    qla2xxx
>>> [3]    qla2xxx
>>>
>>> Or, script it:
>>>
>>> [elm3b79 tmp]$ more xx.sh
>>> #! /bin/sh
>>>
>>> hdir=3D/sys/class/scsi_host
>>>
>>> for i in ${hdir}/host*
>>> do
>>>         host_dir=3D$(cd ${i}/device;/bin/pwd)
>>>         driver_dir=3D$(cd ${host_dir}/../driver;/bin/pwd)
>>>         module=3D$(basename ${driver_dir})
>>>         # echo ${i} is in: ${host_dir}
>>>         echo "${i} module (driver) is: ${module}"
>>> done
>>>
>>> [elm3b79 tmp]$ sh ./xx.sh
>>> /sys/class/scsi_host/host0 module (driver) is: qla1280
>>> /sys/class/scsi_host/host1 module (driver) is: qla1280
>>> /sys/class/scsi_host/host2 module (driver) is: qla2300
>>> /sys/class/scsi_host/host3 module (driver) is: qla2300
>>
>>
>>
>> Patrick,
>> lsscsi currently uses proc_name so it needs to be
>> changed to use the above logic (if LLDs are going
>> to stop populating proc_name).
>>
>> It has been suggested that I extend lsscsi to show
>> transport info (as seen from the HBA) found in the
>> various *_transport directories in sysfs.
>>
>> Also I have been thinking about ways to list less
>> tha all scsi devices. For example: "lsscsi 1:0:3:0"
>> to look at one device and "lsscsi 1:-" for all scsi
>> devices hanging off host1. I'm not sure whether
>> "lsscsi /dev/sda" is a good idea. Any suggestions?
>>
>> Doug Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
