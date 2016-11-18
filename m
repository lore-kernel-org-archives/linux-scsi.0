From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mpt2sas: Fix secure erase premature termination.
Date: Fri, 18 Nov 2016 12:54:28 +0100
Message-ID: <20161118115428.GA12997@kroah.com>
References: <1479469369-15066-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479469369-15066-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: stable@vger.kernel.org, andrey2805@gmail.com, hch@infradead.org, jejb@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, FusionLinux.pdl@broadcom.com, hare@suse.de, Sathya.Prakash@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 18, 2016 at 05:12:49PM +0530, Suganath Prabu S wrote:
> Problem:
> This is a work around for a bug with LSI Fusion MPT SAS2 when
> pefroming secure erase. Due to the very long time the operation
> takes commands issued during the erase will time out and will trigger
> execution of abort hook. Even though the abort hook is called for
> the specific command which timed out this leads to entire device halt
> (scsi_state terminated) and premature termination of the secured erase.
> 
> Fix:
> Set device state to busy while erase in progress to reject any incoming
> commands until the erase is done. The device is blocked any way during
> this time and cannot execute any other command.
> 
> P.S
> This is a backport from the same fix for mpt3sas driver intended
> for pre-4.4 stable trees.

What is the git commit id of the patch in Linus's tree that matches up
with this one?

thanks,

greg k-h
