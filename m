From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: aic7xxx: Fix unintended sign extension issue
Date: Thu, 25 Oct 2018 16:32:49 +0100
Message-ID: <1540481569.3006.5.camel@linux.vnet.ibm.com>
References: <20181025151334.15622-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025151334.15622-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Hannes Reinecke <hare@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-10-25 at 16:13 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the expression "ahc_inb(ahc, port+3) << 24", the initial value is
> a u8, but is promoted to a signed int, then sign-extended to
> uint64_t.

Why is this, that's highly non intuitive?  The compiler is supposed to
promote to the biggest type, which is uint64_t and then do the
calculation

James
