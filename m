From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] BusLogic: add error handling, fix queuecommand, docs.
Date: Thu, 02 Oct 2003 16:34:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065126868.3839.453.camel@compaq.xsintricity.com>
References: <20031001122316.6f33af9b.rddunlap@osdl.org>
	 <20031001214818.GB1045@beaverton.ibm.com>
	 <20031001144324.60097c36.rddunlap@osdl.org>
	 <20031001173750.68a2c6a5.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:57377 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S263487AbTJBUgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 16:36:15 -0400
In-Reply-To: <20031001173750.68a2c6a5.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

On Wed, 2003-10-01 at 20:37, Randy.Dunlap wrote:
> Here's the updated patch...
> 
> More comments?

Yes!


> @@ -3513,7 +3525,7 @@ int BusLogic_QueueCommand(SCSI_Command_T
>  	{
>  	  Command->result = DID_ERROR << 16;
>  	  CompletionRoutine(Command);
> -	  return 0;
> +	  return 1;
>  	}
>      }
>    /*

Oops, now you're both completing the command and causing the scsi mid
layer to put it on the MLQUEUE.  Bad juju mikey!  Either complete the
command or return 1, but don't do both!

> @@ -3679,6 +3691,7 @@ int BusLogic_QueueCommand(SCSI_Command_T
>  	      BusLogic_DeallocateCCB(CCB);
>  	      Command->result = DID_ERROR << 16;
>  	      Command->scsi_done(Command);
> +	      return 1;
>  	    }
>  	}
>      }

Same.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


