From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 11:04:48 +0100
Message-ID: <20140723100448.GA2540@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1405983961-18782-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com, jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 21, 2014 at 04:06:01PM -0700, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.

OK I've just seen this as I was about to post a similar patch to get
discard going on Hyper-V. Will your patches handle Hyper-V pass through devices
that support discard? The SSD I have here reports the following in the Linux
VM:

# sg_vpd -p lbpv  /dev/sdc
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 0
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 1
  Threshold exponent: 0
  Descriptor present (DP): 0
  Provisioning type: 0

# sg_readcap -l /dev/sdc
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=234441647 (0xdf94baf), Number of logical blocks=234441648
   Logical block length=512 bytes
   Logical blocks per physical block exponent=0
   Lowest aligned logical block address=0
Hence:
   Device size: 120034123776 bytes, 114473.5 MiB, 120.03 GB

-- 
Sitsofe | http://sucs.org/~sits/
