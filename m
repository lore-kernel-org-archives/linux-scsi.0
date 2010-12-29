From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ext4 and scsi commands resubmission
Date: Tue, 28 Dec 2010 22:43:46 -0600
Message-ID: <4D1ABC82.5050909@cs.wisc.edu>
References: <4D19BEF6.5010007@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4D19BEF6.5010007@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Cc: linux-ext4@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/28/2010 04:41 AM, torn5 wrote:
> Hello all,
>
> in open-iscsi, when network connectivity is lost, scsi commands that
> were in-flight at the moment of disconnection are failed to the SCSI layer.
> These get resubmitted up to 5 times by the SCSI layer (or so is written
> in the open-iscsi docs) and after that they are held in the queue
> (device "blocked") until the network connection is restored.
>
> Now the question is: when SCSI resubmits commands to a device, I suppose
> they go to the end of the queue for the device, and not at the head like
> they were. Am I right?

The request goes to eh head. scsi layer calls 
blk_requeue_request->elv_requeue_request-> 
elv_insert(ELEVATOR_INSERT_REQUEUE) and ELEVATOR_INSERT_REQUEUE's case 
falls through to the ELEVATOR_INSERT_FRONT case.
