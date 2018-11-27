From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: vmw_pscsi: Rearrange code to avoid multiple calls
 to free_irq during unload
Date: Tue, 27 Nov 2018 23:12:23 +0300
Message-ID: <20181127201222.GA3095@unbuntlaptop>
References: <1543346933-440-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1543346933-440-1-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, emilne@redhat.com, jgill@vmware.com, devel@linuxdriverproject.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 27, 2018 at 02:28:53PM -0500, Cathy Avery wrote:
> Currently pvscsi_remove calls free_irq more than once as
> pvscsi_release_resources and __pvscsi_shutdown both call
> pvscsi_shutdown_intr. This results in a 'Trying to free
> already-free IRQ' warning and stack trace. To solve the problem
> pvscsi_shutdown_intr has been moved out of pvscsi_release_resources.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

That bug has been there since the driver was introduced in 2009.  It's
so amazing that no one has fixed it until now...

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
