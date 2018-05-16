From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/7] cxlflash: Acquire semaphore before invoking ioctl
 services
Date: Wed, 16 May 2018 10:54:35 -0500
Message-ID: <20180516155435.GC8754@p8tul1-build.aus.stglabs.ibm.com>
References: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1526065522-38933-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1526065522-38933-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 11, 2018 at 02:05:22PM -0500, Uma Krishnan wrote:
> When a superpipe process that makes use of virtual LUNs is terminated or
> killed abruptly, there is a possibility that the cxlflash driver could
> hang and deprive other operations on the adapter.
> 
> The release fop registered to be invoked on a context close, detaches
> every LUN associated with the context. The underlying service to detach
> the LUN assumes it has been called with the read semaphore held, and
> releases the semaphore before any operation that could be time consuming.
> 
> When invoked without holding the read semaphore, an opportunity is created
> for the semaphore's count to become negative when it is temporarily
> released during one of these potential lengthy operations. This negative
> count results in subsequent acquisition attempts taking forever, leading
> to the hang.
> 
> To support the current design point of holding the semaphore on the
> ioctl() paths, the release fop should acquire it before invoking any
> ioctl services.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
