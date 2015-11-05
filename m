From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Thu, 5 Nov 2015 13:01:53 -0600
Message-ID: <563BA7A1.8090104@linux.vnet.ibm.com>
References: <1446632451-22365-1-git-send-email-lvivier@redhat.com>
 <1446632451-22365-4-git-send-email-lvivier@redhat.com>
 <5639E904.1070100@suse.de> <5639F020.4010308@redhat.com>
 <563A01CC.20809@suse.de> <563A8F83.7010601@linux.vnet.ibm.com>
 <563B1899.6050308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <563B1899.6050308@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Laurent Vivier <lvivier@redhat.com>, martin.petersen@oracle.com
Cc: tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/05/2015 02:51 AM, Hannes Reinecke wrote:
> On 11/05/2015 12:06 AM, Brian King wrote:
>> On 11/04/2015 07:02 AM, Hannes Reinecke wrote:
>>> On 11/04/2015 12:46 PM, Laurent Vivier wrote:
>>>>
>>>>
>>>> On 04/11/2015 12:16, Hannes Reinecke wrote:
>>>>> On 11/04/2015 11:20 AM, Laurent Vivier wrote:
>>>>>> QEMU allows until 32 LUNs.
>>>>>>
>>>>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>>>>> ---
>>>>>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
>>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>>>>>> index 04de287..4480d3e 100644
>>>>>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>>>>>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>>>>>> @@ -84,6 +84,7 @@
>>>>>>   */
>>>>>>  static int max_id = 64;
>>>>>>  static int max_channel = 3;
>>>>>> +static int max_lun = 8;
>>>>>>  static int init_timeout = 300;
>>>>>>  static int login_timeout = 60;
>>>>>>  static int info_timeout = 30;
>>>>>> @@ -117,6 +118,8 @@ module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
>>>>>>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
>>>>>>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>>>>>>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
>>>>>> +module_param(max_lun, int, S_IRUGO);
>>>>>> +MODULE_PARM_DESC(max_lun, "Maximum LUN value [Default=8]");
>>>>>>  
>>>>>>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>>>>>>  				struct ibmvscsi_host_data *hostdata);
>>>>>> @@ -2289,7 +2292,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>>>>>  		goto init_pool_failed;
>>>>>>  	}
>>>>>>  
>>>>>> -	host->max_lun = 8;
>>>>>> +	host->max_lun = max_lun;
>>>>>>  	host->max_id = max_id;
>>>>>>  	host->max_channel = max_channel;
>>>>>>  	host->max_cmd_len = 16;
>>>>>>
>>>>> Please, don't do this.
>>>>>
>>>>> 'max_lun' should only be set if the HBA / transport has some hard
>>>>> limitations on the number of bytes it can use.
>>>>> Otherwise the scanning algorithm in scsi_scan.c should do the
>>>>> correct thing, independent on the 'max_lun' setting.
>>>>
>>>> So you are saying we can remove the line ?
>>>>
>>> Ho-hum. In principle you could, as ibmvscsi is using SRP internally,
>>> which does support 64 bit LUNs.
>>>
>>> However, due to some weird design decisions there is
>>> the function 'lun_from_dev()', which mangles the incoming LUN number
>>> into something ... else.
>>> Which leaves only 4 bits free for the actual LUN number, requiring
>>> you to use max_lun = 16.
>>>
>>> Personally I would just do away with that function and use the
>>> incoming LUN numbers as is.
>>
>> I pulled out my copy of SAM, what lun_from_dev is doing is translating
>> the incoming bus / id / LUN to a LUN in the logical unit addressing format,
>> as defined in 4.6.9 of SAM-4.
>>
>> --------------------------------------
>> |Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
>> --------------------------------------
>> | n  | (10b) |       Target          |
>> --------------------------------------
>> | n+1|   Bus     |        LUN        |
>> --------------------------------------
>>
>> So this means, in the current implementation, we have 6 bits for target (max=63),
>> 3 bits for bus (max=7), and 5 bits for LUN (max=31). 
>>
>> It might not be a bad idea to enforce these limits on the module parameters. Otherwise
>> we'll have a mess when we run through lun_from_dev...
>>
> Correct. With the current implementation we need to set max_lun to 31.
> 
>> As far as eliminating lun_from_dev and just passing the LUN through, I don't think we
>> can do that. The LUN list returned by Report LUNs to a VSCSI disk assumes we are
>> doing the translation above.
>>
> ? How can that be ?

I was just going by what sg_luns returned on a VSCSI disk:

[root@powerio-blue-lp6 ~]# lsscsi
[0:0:1:0]    disk    AIX      VDASD            0001  /dev/sda 
[0:0:2:0]    cd/dvd  AIX      VOPTA                  /dev/sr0 
[0:0:3:0]    disk    AIX      VDASD            0001  /dev/sdb 
[0:0:4:0]    disk    AIX      VDASD            0001  /dev/sdc 
[0:0:7:0]    cd/dvd  AIX      VOPTA                  /dev/sr1 

[root@powerio-blue-lp6 ~]# sg_luns /dev/sda
Lun list length = 8 which imples 1 lun entry
Report luns [select_report=0x0]:
    0000000000000000
[root@powerio-blue-lp6 ~]# sg_luns /dev/sdb
Lun list length = 8 which imples 1 lun entry
Report luns [select_report=0x0]:
    0000000000000000

This is without your patch, but I don't think there should be any filtering of
report luns even in this case. Its what the VIOS is returning that is at
issue here. 

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
