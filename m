From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
 storage protocol version
Date: Wed, 9 Jul 2014 01:40:55 -0700
Message-ID: <20140709084055.GB6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404866812-26950-2-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:46PM -0700, K. Y. Srinivasan wrote:
> Going forward it is possible that some of the commands that are not currently
> implemented will be implemented on future Windows hosts. Make command filtering
> depend on the host version.

> +	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
> +		/*
> +		 * On legacy hosts filter unimplemented commands.
> +		 */
> +		if (!storvsc_scsi_cmd_ok(scmnd)) {
> +			scmnd->scsi_done(scmnd);
> +			return 0;
> +		}

So post-Win8 versions don't need command filering as they can properly
reject commands they don't understand?  If that's the case please state
it in the patch description.
