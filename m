From: Jerome Martin <jxm@netiant.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 11:11:26 +0200
Message-ID: <542A73BE.2080501@netiant.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <542A722E.5030109@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Luigi Tarenga <luigi.tarenga@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Hi Luigi,

On 09/30/2014 11:04 AM, Luigi Tarenga wrote:
> Hi Jerome,
> thanks for the promptly reply. I'm not using the -fb branch.

Yes you are:

> I have installed targetcli from centos rpm:
> # rpm -qi fcoe-target-utils-2.0rc1.fb16-5.el6.noarch

See the version here? ....fb16...

> I'm not sure what is the initscript you mention. I have in /etc/init.d/:
> # ls fcoe-target iscsi*
> fcoe-target  iscsi  iscsid
>
> but afaik those are for the initiatior or fcoe-target...

Well, given the name of the redhat package, my best best would be 
fcoe-target :-)

> I tryed to manually create the directory but nothing changed:

Mmmh. ok.

I'll have to take a look at that installing a centos 6.5 box, or we can 
wait for Andy (who maintains the fb branch) to be around, whichever 
comes first. I would still try that initscript first though :-)

> # ll /sys/kernel/config/target/
> total 0
> drwxr-xr-x 3 root root    0 Sep 30 10:25 core
> drwxr-xr-x 3 root root    0 Sep 30 10:59 iscsi
> -r--r--r-- 1 root root 4096 Sep 30 10:59 version
> [root@lizard init.d]#
> [root@lizard init.d]# targetcli ls
> o- /
> .........................................................................................................................
> [...]
>    o- backstores
> ..............................................................................................................
> [...]
>    | o- block
> ....................................................................................................
> [0 Storage Object]
>    | o- fileio
> ...................................................................................................
> [0 Storage Object]
>    | o- pscsi
> ....................................................................................................
> [0 Storage Object]
>    o- loopback
> ..........................................................................................................
> [0 Targets]
>
> the only difference I see is that the module is now used:
> iscsi_target_mod      205464  1
>
> and I can't rmmod it.
>
> Luigi
>
> On 09/30/2014 10:56 AM, Jerome Martin wrote:
>> Hi Luigi,
>>
>> I am not 100% sure of that, as you are using the -fb branch, but it
>> seems to me you haven't got the /sys/kernel/config/target/iscsi/
>> directory. Normally this is created by the initscript.
>>
>> Can you either try creating it manually, and/or starting the target
>> service susing the initscript ?
>>
>> Best,
>> --
>> Jerome
>>
>> On 09/30/2014 10:52 AM, Luigi Tarenga wrote:
>>> hi everybody,
>>> I write to you for a problem that sound as my simple mistake
>>> but I can't really find a solution after googling and reading
>>> official doc.
>>>
>>> I'm trying to configure a iscsi target on a centos 6.5 box with
>>> a custom kernel compiled from vanilla 3.16.3.
>>>
>>> I have compile:
>>> CONFIG_TARGET_CORE=m
>>> CONFIG_ISCSI_TARGET=m
>>> CONFIG_CONFIGFS_FS=m
>>>
>>> I mount configfs:
>>> # mount | grep config
>>> configfs on /sys/kernel/config type configfs (rw)
>>>
>>> manually load iscsi_target_mod (and this show nothing in dmesg)
>>>
>>> and when I run targetcli ls command this is the output:
>>> # targetcli ls
>>> o- /
>>> .....................................................................
>>> [...]
>>>    o- backstores
>>> .......................................................... [...]
>>>    | o- block ................................................ [0
>>> Storage Object]
>>>    | o- fileio ............................................... [0
>>> Storage Object]
>>>    | o- pscsi ................................................ [0
>>> Storage Object]
>>>    o- loopback ...................................................... [0
>>> Targets]
>>>
>>> I can't see "o- iscsi" so I can't create the iscsi target i need...
>>>
>>> # targetcli version
>>> targetcli version 2.0rc1.fb16
>>>
>>> $ ls /sys/kernel/config/target/
>>> core  version
>>>
>>> # lsmod | grep scsi
>>> iscsi_target_mod      205464  0
>>> target_core_mod       229493  1 iscsi_target_mod
>>> configfs               22151  3 iscsi_target_mod,target_core_mod
>>> scsi_mod               93246  6
>>> iscsi_target_mod,target_core_mod,sg,sd_mod,sr_mod,libata
>>>
>>> any idea of what I can check?
>>>
>>> many thanks in advance
>>> Luigi
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> target-devel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
