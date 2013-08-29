From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [RFC/PATCH 2/2] scsi: ufs: requests completion handling
Date: Thu, 29 Aug 2013 20:37:37 +0300
Message-ID: <06be01cea4de$77b79ce0$6726d6a0$@codeaurora.org>
References: <1377766493-5269-1-git-send-email-rshvili@codeaurora.org> <1377768462.2223.70.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1377768462.2223.70.camel@dabdike>
Content-language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Raviv Shvili' <rshvili@codeaurora.org>
Cc: scsi-misc@vger.kernel.org, linux-arm-msm@vger.kernel.org, "'open list:SCSI SUBSYSTEM'" <linux-scsi@vger.kernel.org>, 'open list' <linux-kernel@vger.kernel.org>, merez@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

See reply inline

Thanks,
Yaniv

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Thursday, August 29, 2013 12:28 PM
To: Raviv Shvili
Cc: scsi-misc@vger.kernel.org; linux-arm-msm@vger.kernel.org; open list:SCSI
SUBSYSTEM; open list
Subject: Re: [RFC/PATCH 2/2] scsi: ufs: requests completion handling

On Thu, 2013-08-29 at 11:54 +0300, Raviv Shvili wrote:
> The patch solves the request completion report order. At the current 
> implementation, when multiple requests end at the same interrupt call, 
> the requests reported as completed according to a bitmap scan from the 
> lowest tags to the highest, regardless the requests priority. That 
> cause to a priority unfairness and starvation of requests with a high
tags.

It does?  Why?  What seems to happen is that you loop over all the pending
requests and call done for them.  The way SCSI handles done commands is that
it queues them to the softirq, so there doesn't look to be any real
unfairness problem here.

<yaniv> The unfairness is that currently the loop goes over the tags from 0
to NUTRS(i.e 31), and calls done() at this order, regardless of the
task_attribute they hold.
Also, the benefit in performance is that instead of going over NUTRS (32)
iteration, we simple call done() only for the exact of completed request
(and according to their task_attribute priority). 

Scenario: a new HEAD_OF_QUEUE request that is completed during the current
loop, will be served only in the next interrupt (since the DOORBELL will be
read again only in the next interrupt), and saying it is a high tag, it will
be completed lastly. This patch will fix it, as I see that.



> SCSI Architecture Model 5 defines 3 task-attributes that are part of 
> each SCSI command, and integrated into each Command UPIU. The 
> task-attribute is for the device usage, it determines the order in 
> which the device prioritizes the requests.
> The task-attributes according to their priority are (from high to low):
> HEAD OF QUEUE, ORDERED and SIMPLE. There is a queue per task-attribute.
> Each request is assigned to one of the above sw queues according to 
> its task attribute field.
> Requests which are not SCSI commands (native UFS) will be assigned to 
> the lowest priority queue, since there is no much difference between 
> completing it first or last..
> 
> When request is completed, we go over the queues (from the queue's 
> highest priority to the lowest) and report the completion.
> 
> Requests are removed from the queue in case of command completion or 
> when aborting pending command.

Since we never use anything other than SIMPLE attributes, this rather looks
like a solution in search of a problem.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
