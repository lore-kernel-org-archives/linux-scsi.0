From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [Patch v2] Storvsc: Select channel based on available
 percentage of ring buffer to write
Date: Fri, 20 Apr 2018 08:50:43 -0700
Message-ID: <20180420085043.3a678b89@xeon-e3>
References: <20180419215424.3557-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180419215424.3557-1-longli@linuxonhyperv.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@linuxonhyperv.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 19 Apr 2018 14:54:24 -0700
Long Li <longli@linuxonhyperv.com> wrote:

> From: Long Li <longli@microsoft.com>
> 
> This is a best effort for estimating on how busy the ring buffer is for
> that channel, based on available buffer to write in percentage. It is still
> possible that at the time of actual ring buffer write, the space may not be
> available due to other processes may be writing at the time.
> 
> Selecting a channel based on how full it is can reduce the possibility that
> a ring buffer write will fail, and avoid the situation a channel is over
> busy.
> 
> Now it's possible that storvsc can use a smaller ring buffer size
> (e.g. 40k bytes) to take advantage of cache locality.
> 
> Changes.
> v2: Pre-allocate struct cpumask on the heap.
> Struct cpumask is a big structure (1k bytes) when CONFIG_NR_CPUS=8192 (default
> value when CONFIG_MAXSMP=y). Don't use kernel stack for it by pre-allocating
> them using kmalloc when channels are first initialized.
> 
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Stephen Hemminger <sthemmin@microsoft.com>
