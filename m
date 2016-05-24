From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Fix for hang of Ordered task in TCM
Date: Mon, 23 May 2016 22:31:44 -0700
Message-ID: <1464067904.22249.53.camel@haakon3.risingtidesystems.com>
References: <1463177741-4385-1-git-send-email-mikecyr@linux.vnet.ibm.com>
	 <1463550825.22249.17.camel@haakon3.risingtidesystems.com>
	 <82ddb84d-1a3c-f7ad-3f91-0a9506317bdf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <82ddb84d-1a3c-f7ad-3f91-0a9506317bdf@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-05-18 at 14:35 -0500, Michael Cyr wrote:
> On 5/18/16 12:53 AM, Nicholas A. Bellinger wrote:
> > Hi Michael,
> >
> > On Fri, 2016-05-13 at 17:15 -0500, Michael Cyr wrote:
> >> If a command with a Simple task attribute is failed due to a Unit
> >> Attention, then a subsequent command with an Ordered task attribute will
> >> hang forever.  The reason for this is that the Unit Attention status is
> >> checked for in target_setup_cmd_from_cdb, before the call to
> >> target_execute_cmd, which calls target_handle_task_attr, which in turn
> >> increments dev->simple_cmds.  However, transport_generic_request_failure
> >> still calls transport_complete_task_attr, which will decrement
> >> dev->simple_cmds.  In this case, simple_cmds is now -1.  So when a
> >> command with the Ordered task attribute is sent, target_handle_task_attr
> >> sees that dev->simple_cmds is not 0, so it decides it can't execute the
> >> command until all the (nonexistent) Simple commands have completed.
> >>
> > Thanks for reporting this bug.  Comments below.

<SNIP>

> > So AFAICT for delayed commands, the above patch ends up skipping these
> > three checks subsequently when doing __target_execute_cmd() directly
> > from target_restart_delayed_cmds(), no..?
> >
> > After pondering this some more, what about moving these checks into
> > __target_execute_cmd() to handle both target_core_transport.c cases
> > instead..?
>>
> You're right, __target_execute_cmd is clearly the right place for the 
> checks.
>
> > We'll also need a parameter for internal COMPARE_AND_WRITE usage
> > within compare_and_write_callback(), to bypass checks upon secondary
> > ->execute_cmd() WRITE payload submission after READ + COMPARE has
> > completed successfully.
>>
> I'm still learning about the target code, and I was unaware of 
> COMPARE_AND_WRITE.  Thanks for pointing this out to me.  You're right 
> here too, we need to make sure we only make the tests when the Compare 
> and Write is first executed (to do the read), and not later when the 
> write is done.
> >
> > WDYT..?
>>
> You've covered all the places that call __target_execute_cmd, so I think 
> it's good.

Thanks for the feedback.

Given the nature of the change, it needs some more Reviewed-by +
Tested-By (across different drivers) ahead of pushing this patch into
mainline.

So for the moment it's in target-pending/queue as a post v4.7-rc1 item
here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue&id=0c141c33b667b6538e38b87db87232523bcd4f5b
