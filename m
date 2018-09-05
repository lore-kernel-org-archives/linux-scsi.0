From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V12 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Wed, 5 Sep 2018 15:35:36 +0530
Message-ID: <76f3caa9-5fda-2feb-33d7-d2f56ba457d1@codeaurora.org>
References: <1535626003-4966-1-git-send-email-sayalil@codeaurora.org>
 <1535626003-4966-3-git-send-email-sayalil@codeaurora.org>
 <317ec142-2238-ce9f-adba-d6335b1fab8e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <317ec142-2238-ce9f-adba-d6335b1fab8e@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: stummala@codeaurora.org, jlbec@evilplan.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 8/31/2018 12:42 PM, Adrian Hunter wrote:
> On 30/08/18 13:46, Sayali Lokhande wrote:
>> This patch adds configfs support to provision UFS device at
>> runtime. This feature can be primarily useful in factory or
>> assembly line as some devices may be required to be configured
>> multiple times during initial system development phase.
>> Configuration Descriptors can be written multiple times until
>> bConfigDescrLock attribute is zero.
>>
>> Configuration descriptor buffer consists of Device and Unit
>> descriptor configurable parameters which are parsed from vendor
>> specific provisioning file and then passed via configfs node at
>> runtime to provision ufs device.
>> CONFIG_CONFIGFS_FS and CONFIG_UFS_PROVISION needs to be enabled
>> for using this feature.
>>
>> Usage:
>> 1) To read current configuration descriptor with index X
>>     (where index X can be 0/1/2/3) :
>>     cat /config/XXXX.ufshc/ufs_config_desc_X
>>
>> 2) To write configuration descriptor with index X :
>>     echo <config_desc_buf> > /config/XXXX.ufshc/ufs_config_desc_X
>>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
> <SNIP>
>
>> +static struct configfs_attribute ufshcd_attr_provision_0 = {
> Actually, wasn't the original suggestion to use a binary attribute? i.e.
> configfs_bin_attribute
Yes. we did discuss about having binary attribute in between , but then 
it was thought if anyone who wants to use this interface from a shell 
script, it will be much easier to write multiple ASCII attributes than a 
single binary attribute.  It seemed more readable for users and 
easier/comfortable to compare any value to default spec value(if required).
