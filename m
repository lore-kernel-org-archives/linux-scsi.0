From: cang@codeaurora.org
Subject: Re: [PATCH] scsi: ufs-qcom: add number of lanes per direction
Date: Tue, 27 Feb 2018 13:22:11 +0800
Message-ID: <f52a0ca12ca45b41467959ee7b5601fe@codeaurora.org>
References: <20180205121021.11012-1-cang@codeaurora.org>
 <20180209022915.2kki7avsia2k7tjp@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180209022915.2kki7avsia2k7tjp@rob-hp-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Noa Rubens <noag@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-02-09 10:29, Rob Herring wrote:
> On Mon, Feb 05, 2018 at 08:02:07PM +0800, Can Guo wrote:
>> From: Gilad Broner <gbroner@codeaurora.org>
>> 
>> Different platforms may have different number of lanes for the UFS 
>> link.
>> Add parameter to device tree specifying how many lanes should be
>> configured for the UFS link. And don't print err message for clocks
>> that are optional, this leads to unnecessary confusion about failure.
>> 
>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt 
>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index 5357919..4cee3f9 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -31,6 +31,9 @@ Optional properties:
>>  			  defined or a value in the array is "0" then it is assumed
>>  			  that the frequency is set by the parent clock or a
>>  			  fixed rate clock source.
>> +- lanes-per-direction:	number of lanes available per direction - 
>> either 1 or 2.
>> +			Note that it is assume same number of lanes is used both 
>> directions at once.
> 
> Seems reasonable until someone does not make things symmetrical. We
> should design for that case.
> 
You are right, I will make changes like using lanes-tx and lanes-rx for 
Tx/Rx links for asymmetrial senarios and upload V2 patch
>> +			If not specified, default is 2 lanes per direction.
>> 
>>  Note: If above properties are not defined it can be assumed that the 
>> supply
>>  regulators or clocks are always on.
