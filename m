From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle
 TEST_UNIT_READY failure
Date: Wed, 9 Jul 2014 01:46:44 -0700
Message-ID: <20140709084644.GH6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-8-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404866812-26950-8-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:52PM -0700, K. Y. Srinivasan wrote:
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1023,6 +1023,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
>  		case ATA_12:
>  			set_host_byte(scmnd, DID_PASSTHROUGH);
>  			break;
> +		/*
> +		 * On Some Windows hosts TEST_UNIT_READY command can return
> +		 * SRB_STATUS_ERROR, let the upper level code deal with it
> +		 * based on the sense information.
> +		 */
> +		case TEST_UNIT_READY:
> +			break;

Don't we need to set an error in the command for the error handler to
take action?  Or is this propagated elsewhere?
