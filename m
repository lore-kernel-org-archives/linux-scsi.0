From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/6] hv:scsi:Untangle the storage protocol negotiation
 from the vmbus protocol negotiation.
Date: Mon, 1 Jun 2015 13:42:37 +0300
Message-ID: <20150601104237.GU28762@mwanda>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1432931359-14473-3-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org, "keith.mange@microsoft.com" <keith.mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 29, 2015 at 01:29:16PM -0700, K. Y. Srinivasan wrote:
> -	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status != 0)
> +	if (vstor_packet->status != 0) {
> +		ret = -EINVAL;
>  		goto cleanup;
> +	}

There is not actually any cleanup, goto cleanup is just a do-nothing
goto.

In the original code, we returned success here.  That always looked like
a "forgot to set the error code" bug to me, but do-nothing labels always
introduce ambiguous looking "forgot to set the error code" bugs so I can
never be positive.

Could you take a look at the other "goto cleanup;" places in this
function and maybe add a comment, change it to something more clear like
"return 0;" or fix the error code?

regards,
dan carpenter
