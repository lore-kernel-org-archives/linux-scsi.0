From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Date: Thu, 10 Jul 2014 03:18:49 -0700
Message-ID: <20140710101849.GD1151@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1404866812-26950-7-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, jasowang@redhat.com, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, stable@vger.kernel.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>  	default:
>  		vm_srb->data_in = UNKNOWN_TYPE;
> -		vm_srb->win8_extension.srb_flags = 0;
> +		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
> +						     SRB_FLAGS_DATA_OUT);

This would usually be a command that doesn't transfer data (e.g.
TEST_UNIT_READY or SYNCHRONIZE_CACHE), do you really want to set the in
and out flags here?
