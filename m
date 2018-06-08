From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/7] Enable UFS provisioning via Linux
Date: Fri, 8 Jun 2018 15:30:52 +0300
Message-ID: <b844b80f-9f6f-10f7-6dfd-f92d905738e3@intel.com>
References: <20180529181740.195362-1-evgreen@chromium.org>
 <MWHPR04MB11372C75BFC9416BAF5E81A19A630@MWHPR04MB1137.namprd04.prod.outlook.com>
 <CAE=gft4LoNiRtxgTA_ZPghZGEVOzu_GAwMgqhs-8NCYVgj_AVw@mail.gmail.com>
 <MWHPR04MB11370AED823FB608218CB9AD9A600@MWHPR04MB1137.namprd04.prod.outlook.com>
 <CAE=gft5Vk3neDkyvmVf4CkBQQPVK=wXp=5jJ8n0uaosEwWUOAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft5Vk3neDkyvmVf4CkBQQPVK=wXp=5jJ8n0uaosEwWUOAg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Stanislav.Nijnikov@wdc.com
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>, Alex.Lemberg@wdc.com, Avri.Altman@wdc.com
List-Id: linux-scsi@vger.kernel.org

On 04/06/18 17:59, Evan Green wrote:
> On Sun, Jun 3, 2018 at 3:21 AM Stanislav Nijnikov
> <Stanislav.Nijnikov@wdc.com> wrote:
>>
>>
>>
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org> On Behalf Of Evan Green
>>> Sent: Friday, June 1, 2018 5:44 PM
>>> To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
>>> Cc: Vinayak Holikatti <vinholikatti@gmail.com>; jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
>>> kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Gwendal Grignou <gwendal@chromium.org>; Alex Lemberg
>>> <Alex.Lemberg@wdc.com>; Avri Altman <Avri.Altman@wdc.com>
>>> Subject: Re: [PATCH 0/7] Enable UFS provisioning via Linux
>>>
>>> Hi Stanislav. Thanks for taking a look. Responses below.
>>>
>>> On Thu, May 31, 2018 at 3:04 AM Stanislav Nijnikov
>>> <Stanislav.Nijnikov@wdc.com> wrote:
>>>>
>>>> Hi Evan,
>>>> I have some generic notes:
>>>> - Why to create new sysfs entries for the configuration descriptor fields if they are just duplication of fields in the device and unit
>>> descriptors? And the sysfs representation of the device and unit descriptors is existing already.
>>>
>>> Well, UFS describes them as different descriptors. I worry that if I
>>> add a bunch of clever logic to hide the config descriptor behind other
>>> descriptors, there might be trouble later if 1) there is a quirky
>>> device that doesn't reflect the values between descriptors quite the
>>> same way or at the same time, or 2) if a later UFS spec adds more
>>> configuration descriptor fields that don't exactly reflect into other
>>> non-config descriptors, the cleverness will look awkward.
>>
>> No additional logic will be required to attach write functionality to the
>> existing entries instead of new defined ones. It will reduce the patch
>> size significantly. And there will be no need for the unit selector
>> mechanism which I'm not sure will be accepted by the SCSI community.
>>
> 
> So this would be modifying the existing sysfs entries so that reads
> still come from the device and unit descriptors, but writes go to
> equivalent fields in the config descriptor? I can explore that
> approach. Alternatively, if the unit selector mechanism is not
> desired, I could dynamically create sysfs directories for each unit in
> the config descriptor, but still bring out the config descriptor
> values as separate entries. (I still worry a bit about smashing the
> descriptors together as the UFS spec called them out as different).

If you use the unit attributes, how do you configure units that do not yet
exist?

Perhaps it is better to represent the configuration descriptors exactly as
they are defined in the specification.  Probably not worth exposing them at
all if the configuration is locked (attribute bConfigDescrLock == 1).

Note also that the 2.1 spec. defines  bConfDescContinue which allows updates
to be grouped and committed together.
