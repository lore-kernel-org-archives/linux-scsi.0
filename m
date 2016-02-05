From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/4] qla2xxx: Add DebugFS node to show irq vector's cpuid
Date: Fri, 5 Feb 2016 11:42:24 -0800
Message-ID: <56B4FB20.9080302@sandisk.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
 <1454604319-27947-5-git-send-email-himanshu.madhani@qlogic.com>
 <56B39653.6090903@sandisk.com>
 <883FB6FF-C20D-4352-AA6E-CCA5332F6379@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <883FB6FF-C20D-4352-AA6E-CCA5332F6379@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/05/2016 10:49 AM, Quinn Tran wrote:
> On 2/4/16, 10:20 AM, "Bart Van Assche" <bart.vanassche@sandisk.com> w=
rote:
>> On 02/04/2016 08:45 AM, Himanshu Madhani wrote:
>>> From: Quinn Tran <quinn.tran@qlogic.com>
>>>
>>>> cat /sys/kernel/debug/qla2xxx/*/irq_cpuid
>>> qla2xxx_81
>>>               IRQ Name  Vector  CPUID
>>>      qla2xxx (default)  150     9
>>>        qla2xxx (rsp_q)  151     9
>>>       qla2xxx (atio_q)  152     9
>>
>> Hello Quinn and Himanshu,
>>
>> Do you think it would be possible to generate this information via a
>> user-space script from /proc/interrupts and /proc/irq/<n>/smp_affini=
ty?
>>
>> Thanks,
>>
>> Bart.
>
> Bart,
>=20
> Currently, the data from the 2 mentioned =E2=80=9C/proc=E2=80=9D entr=
y points were not able to give us the host_id/port & the vector informa=
tion.
>=20
> The 2 alternatives are i) change the driver code to register host id =
along with the vector and add script to combine the infos,  ii) 1 code =
change that gives us the summary.
>=20
> We choose path 2 for the ease of usage.

Hello Quinn,

Please have another look at /proc/interrupts and
/proc/irq/<n>/smp_affinity. The information that is exported through
this patch is already available there. This is why I think this patch
should be dropped. All you need is something like the shell script belo=
w.

Sample output (nn =3D NUMA node; num =3D IRQ vector):

=3D=3D=3D=3D IRQs
nn cpu num count name
0  6   105  1753 PCI-MSI-edge      qla2xxx (rsp_q)                =20
1  1   104  8781 PCI-MSI-edge      qla2xxx (default)              =20
1  1   107  1629 PCI-MSI-edge      qla2xxx (rsp_q)                =20

The shell script that produced the above output:

ppi() {
    { echo "$(<"/sys/devices/system/cpu/cpu$1/topology/physical_package=
_id")" || echo '?'; } 2>/dev/null
}

echo "=3D=3D=3D=3D IRQs"
printf "%-2s %-3s %-3s %12s %-50s\n" nn cpu num count name
cat /proc/interrupts |
  while read line; do
    num=3D"$(echo "$line" | sed -n 's/^[[:blank:]]*\([0-9]*\):\([0-9[:b=
lank:]]*\)\(.*\)/\1/p')"
    [ -z "$num" ] && continue
    count=3D0
    for c in $(echo "$line" | sed -n 's/^[[:blank:]]*\([0-9]*\):\([0-9[=
:blank:]]*\)\(.*\)/\2/p'); do
	count=3D$((count+c))
    done
    name=3D"$(echo "$line" | sed -n 's/^[[:blank:]]*\([0-9]*\):\([0-9[:=
blank:]]*\)\(.*\)/\3/p')"
    if [ -r "/proc/irq/$num/smp_affinity_list" ]; then
	al=3D"$(<"/proc/irq/$num/smp_affinity_list")"
	cpu=3D"${al/-*}"=20
	cpu=3D"${cpu/,*}"
	ppi=3D"$(ppi "$cpu")"
    else
	cpu=3D"?"
	ppi=3D"?"
    fi
    printf "%-2s %-3d %-3d %12d %-50s\n" "$ppi" "$cpu" "$num" "$count" =
"$name"
  done |
  sort -n -k1,3

Thanks,

Bart.
