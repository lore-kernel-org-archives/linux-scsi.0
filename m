From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5 - Questions
Date: Wed, 1 Oct 2003 12:19:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031001191931.55234.qmail@web60202.mail.yahoo.com>
References: <20030925091949.A6827@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60202.mail.yahoo.com ([216.109.118.97]:65426 "HELO
	web60202.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262161AbTJATTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2003 15:19:32 -0400
In-Reply-To: <20030925091949.A6827@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org


See below ...
--- Christoph Hellwig <hch@infradead.org> wrote:
> More comments:
> 
>  - unh_iscsi/security should really go away.  We have a nice crypto
> API
>    in 2.6 and late 2.4, but authentification really shouldn't be done
>    in kernelspace anyway.

    We're in the process of reviewing that API.

>  - kill iscsi_device.c.  A scsi LLDD has no business messing with
> device
>    nodes..
  DONE .. We never used it anyway .
>  - you're comment style is strange.  In kernel code we tend to use
> 
> /*
>  * Foo, blah
>  * baz..
>  */
> 
> not
> 
> /*
> 
> */
> 

  Multiple authors tend to use different comment styles.
  We've been using more of the standard style recently.
> but that's just a minor nitpick.
> 
> Having the module description over the copyright boilerplate also is
> very strange.

 FIXED.
> 
>  - your split into common/ and initiator/ is strange.  You can build
>    multiple modules in one directory and that would cleanup your
>    includes mess nicely
    Common is shared with another module and commands 
    that is not being included . We're likely keep what is 
    really common and migrate other pieces to an appropriate home.

>  - having a single host for all of iscsi looks strange.  Why do you
>    do that?

 The HBA is one entity for iSCSI. I'm open for suggestions,
 or clarification.
>  - the #ifdef K26 is totally unreadble.  Especially when it's around
>    code that works for both 2.4 and 2.6..
     Well, it was a means to mark the differences in what 
     use to work in 2.4 and required tweeking in 2.6. It also 
     highlighted what really needs more attention. Eventually 
     it will go away. 
>  - kill my_kmallocd / my_free

 We use these as a debug means to find memory links and 
 fix them. It's not intended as a garbage collector if that was
your impression. We will certain make corresponding changes so that it
can be made wrapped in DEBUG defines and use standard malloc/free.
 We would prefer to keep it.
>  - you seems to not handle lots of error returns, e.g. from
> down_interruptible
>    or kernel_thread
    Thanks. We should be more aware of possible errors.
>  - the UNH_LOCK/UNH_UNLOCK obsfucation hinders reading.
     Again. We wrapped the irqsave/restore locks in a define
     for debugging . We would like to keep them, perhaps with 
     a better/more informative name.
>  - kill ISCSI_INITIATOR, there's no need for this #define - just
> initialize
>    the host template directly

   DONE !

Thanks,
John.

> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


__________________________________
Do you Yahoo!?
The New Yahoo! Shopping - with improved product search
http://shopping.yahoo.com
