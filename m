From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Tue, 15 Mar 2016 06:40:09 -0700
Message-ID: <20160315134009.GA3595@infradead.org>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1457819568-6586-1-git-send-email-kys@microsoft.com>
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
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, hare@suse.de, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 12, 2016 at 01:52:48PM -0800, K. Y. Srinivasan wrote:
> The default user scan function associated with FC (fc_user_scan)
> is not suitable for FC hosts on Hyper-V since we don't have
> an rport associated with FC host on Hyper-V . Set it to NULL so we can
> support manual scan of FC targets on Hyper-V.

This isn't really how the FC transport class in intended to work, but
neither is the eh_timed_out (which I haven't seen in my tree yet).

It sounds like storvsc simply shouldn't attach to the FC transport
if it doesn't actually look like a FC HBA.
