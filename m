From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] tcmu: Allow reconfig to handle multiple attributes
Date: Mon, 29 Jan 2018 11:46:05 -0600
Message-ID: <1c578d10-fd65-7d1f-e328-45774f3b41da@linux.vnet.ibm.com>
References: <20180104161100.15330-1-bryantly@linux.vnet.ibm.com>
 <5A565AC5.7010905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5A565AC5.7010905@redhat.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, nab@linux-iscsi.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 1/10/18 12:26 PM, Mike Christie wrote:

> On 01/04/2018 10:11 AM, Bryant G. Ly wrote:
>> This patch allows for multiple attributes to be reconfigured
>> and handled all in one call as compared to multiple netlinks.
>>
>> Example:
>> set attribute dev_reconfig=dev_config=fbo//home/path:dev_size=2147483648
>>
> I know I suggested this, but I think I was wrong. If we have to support
> other apps that work in reverse to targetcli+tcmu-runner where the
> tcmu-runner equivalent app sets things up then contacts the kernel,
> let's just not do passthrough operations like this for reconfig. There
> is no need to bring in the kernel.
>
> For the initial config we can still do it since we have to maintain
> compat, but for major reconfigs like this let's just have targetcli
> contact tcmu-runner, then runner can update the kernel if needed.
>
> So in targetcli and runner copy the check_config stuff, and add a
> reconfig callout that works like it. We then do not have this weird
> kernel passthrough and do not have to worry about the non
> targetcl-tcmu-runner type of model.
>
>
>
So you basically want me to use DBUS correct? Connect a GCallback function

with reconfig function and use DBUS to pass info back to kernel if necessary?

-Bryant
