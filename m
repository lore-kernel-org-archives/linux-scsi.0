From: Georgi Djakov <georgi.djakov@linaro.org>
Subject: Re: [<PATCH v1> 1/1] scsi: qcom-ufs: Add support for bus voting using
 ICB framework
Date: Mon, 28 Jan 2019 17:34:09 +0200
Message-ID: <264ad328-a0d0-9e78-f7ae-bdc084bab38f@linaro.org>
References: <cover.1548312692.git.asutoshd@codeaurora.org>
 <d6aa4d9bd29bbb2c3ee78e6635d4704e4113a26e.1548312692.git.asutoshd@codeaurora.org>
 <e91d4007-edab-da66-e241-bdf55bcf58aa@linaro.org>
 <4f58c58a-aeb6-6cad-96ac-43f6843715ce@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4f58c58a-aeb6-6cad-96ac-43f6843715ce@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Asutosh Das (asd)" <asutoshd@codeaurora.org>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Asutosh,

On 1/25/19 12:27, Asutosh Das (asd) wrote:
> On 1/24/2019 5:16 PM, Georgi Djakov wrote:
[..]>>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> index a99ed55..94249ef 100644
>>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> @@ -45,6 +45,18 @@ Optional properties:
>>>   Note: If above properties are not defined it can be assumed that
>>> the supply
>>>   regulators or clocks are always on.
>>>   +* Following bus parameters are required:
>>> +interconnects
>>> +interconnect-names
>>
>> Is the above really required? Are the interconnect bandwidth requests
>> required to enable something critical to UFS functionality?
>> Would UFS still work without any bandwidth scaling, although for example
>> slower? Could you please clarify.
> Yes - UFS will still work without any bandwidth scaling - but the
> performance would be terrible.

Ok, thanks for clarifying! Then the properties should be optional. Maybe
we can also mention in the commit text how much the performance would
improve with this patch.

>>
>>> +- Please refer to Documentation/devicetree/bindings/interconnect/
>>> +  for more details on the above.
>>> +qcom,msm-bus,name - string describing the bus path
>>> +qcom,msm-bus,num-cases - number of configurations in which ufs can
>>> operate in
>>> +qcom,msm-bus,num-paths - number of paths to vote for
>>> +qcom,msm-bus,vectors-KBps - Takes a tuple <ib ab>, <ib ab> (2 tuples
>>> for 2 num-paths)
>>> +                The number of these entries *must* be same as
>>> +                num-cases.
>>
>> DT bindings should be submitted as a separate patch. Anyway, people
>> frown upon putting configuration data in DT. Could we put this data into
>> the driver as a static table instead of DT? Also maybe use ab/pb for
>> average/peak bandwidth.
> The ab/ib value change depending on the target - that's the reasoning
> for putting it in dts file. However, I'm open to ideas as to how else to
> handle this.

As Evan already suggested, it would be best if we can calculate the
bandwidth. Can we do that based on the number of lanes, clock rate and
ufs standard version?
If calculating is really not possible and we have strong arguments for
that, we could add a more specific compatible DT string - for example
qcom,sdm845-ufshc and use per SoC bandwidth tables.

Thanks,
Georgi
