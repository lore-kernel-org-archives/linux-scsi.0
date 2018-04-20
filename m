From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] isci: Fix infinite loop in while loop
Date: Fri, 20 Apr 2018 11:45:51 +0200
Message-ID: <1524217551.3321.4.camel@linux.vnet.ibm.com>
References: <20180420090310.714-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420090310.714-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-04-20 at 10:03 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case when the phy_mask is bitwise anded with the
> phy_index bit is zero the continue statement currently jumps
> to the next iteration of the while loop and phy_index is
> never actually incremented, potentially causing an infinite
> loop if phy_index is less than SCI_MAX_PHS. Fix this by
> jumping to the increment of phy_index.
> 
> [ The goto is used to save one more level of nesting that
> makes the code far wider than 80 columns. ]

what's wrong with replacing the while() with a for() that just works
(removing the increment at the end).  This is effectively open coding a
for loop anyway, which is a pattern we wouldn't want replicated.

James
