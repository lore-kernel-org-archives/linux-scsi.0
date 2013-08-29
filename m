From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC/PATCH 2/2] scsi: ufs: requests completion handling
Date: Thu, 29 Aug 2013 13:27:42 +0400
Message-ID: <1377768462.2223.70.camel@dabdike>
References: <1377766493-5269-1-git-send-email-rshvili@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1377766493-5269-1-git-send-email-rshvili@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Raviv Shvili <rshvili@codeaurora.org>
Cc: scsi-misc@vger.kernel.org, linux-arm-msm@vger.kernel.org, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-08-29 at 11:54 +0300, Raviv Shvili wrote:
> The patch solves the request completion report order. At the current
> implementation, when multiple requests end at the same interrupt call,
> the requests reported as completed according to a bitmap scan from the
> lowest tags to the highest, regardless the requests priority. That cause
> to a priority unfairness and starvation of requests with a high tags.

It does?  Why?  What seems to happen is that you loop over all the
pending requests and call done for them.  The way SCSI handles done
commands is that it queues them to the softirq, so there doesn't look to
be any real unfairness problem here.

> SCSI Architecture Model 5 defines 3 task-attributes that are part of each
> SCSI command, and integrated into each Command UPIU. The task-attribute is
> for the device usage, it determines the order in which the device
> prioritizes the requests.
> The task-attributes according to their priority are (from high to low):
> HEAD OF QUEUE, ORDERED and SIMPLE. There is a queue per task-attribute.
> Each request is assigned to one of the above sw queues
> according to its task attribute field.
> Requests which are not SCSI commands (native UFS) will be assigned to
> the lowest priority queue, since there is no much difference between
> completing it first or last..
> 
> When request is completed, we go over the queues (from
> the queue's highest priority to the lowest) and report
> the completion.
> 
> Requests are removed from the queue in case of command completion
> or when aborting pending command.

Since we never use anything other than SIMPLE attributes, this rather
looks like a solution in search of a problem.

James
