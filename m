From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [<PATCH v1> 1/1] scsi: qcom-ufs: Add support for bus voting using
 ICB framework
Date: Fri, 25 Jan 2019 15:59:37 +0530
Message-ID: <926d2232-67f2-bd3a-ab79-87bbca3a1add@codeaurora.org>
References: <cover.1548312692.git.asutoshd@codeaurora.org>
 <d6aa4d9bd29bbb2c3ee78e6635d4704e4113a26e.1548312692.git.asutoshd@codeaurora.org>
 <CAE=gft6P9ssNp_GRUFJT7BvJUHduorg=-bvi0KytDMWTd0pGew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6P9ssNp_GRUFJT7BvJUHduorg=-bvi0KytDMWTd0pGew@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/24/2019 10:22 PM, Evan Green wrote:
> On Wed, Jan 23, 2019 at 11:02 PM Asutosh Das <asutoshd@codeaurora.org> wrote:
>>
>> Adapt to the new ICB framework for bus bandwidth voting.
>>
>> This requires the source/destination port ids.
>> Also this requires a tuple of values.
>>
>> The tuple is for two different paths - from UFS master
>> to BIMC slave. The other is from CPU master to UFS slave.
>> This tuple consists of the average and peak bandwidth.
>>
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> ---
>>   .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  12 ++
>>   drivers/scsi/ufs/ufs-qcom.c                        | 234 ++++++++++++++++-----
>>   drivers/scsi/ufs/ufs-qcom.h                        |  20 ++
>>   3 files changed, 218 insertions(+), 48 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index a99ed55..94249ef 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -45,6 +45,18 @@ Optional properties:
>>   Note: If above properties are not defined it can be assumed that the supply
>>   regulators or clocks are always on.
>>
>> +* Following bus parameters are required:
>> +interconnects
>> +interconnect-names
>> +- Please refer to Documentation/devicetree/bindings/interconnect/
>> +  for more details on the above.
>> +qcom,msm-bus,name - string describing the bus path
>> +qcom,msm-bus,num-cases - number of configurations in which ufs can operate in
>> +qcom,msm-bus,num-paths - number of paths to vote for
>> +qcom,msm-bus,vectors-KBps - Takes a tuple <ib ab>, <ib ab> (2 tuples for 2 num-paths)
>> +                           The number of these entries *must* be same as
>> +                           num-cases.
> 
> I think we can do away with all of the qcom* ones, right? This should
> be achievable with just interconnects and interconnect-names.
Let me give that a bit more thought - though I'm not sure how that'd work.

> 
> Also, is this patch based on a downstream tree? I don't recognize a
> lot of the context. We'll need a patch that's based on an upstream
> tree.
This was developed on the internal Chrome AU and ported to ufs-next.
Let me check internally on this anyway.

> 
> I'll wait to review the rest of the patch until rev 2, since it's hard
> to reason about the patch with all the downstream stuff in there.
> -Evan
> 

Hi Evan - thanks for the comments.

-asd

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
