From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: Why is (2 < 2) true? Is it a gcc bug?
Date: Fri, 17 Jan 2014 17:00:40 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6A36A2@IRSMSX105.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
 <D9FFE20C522965449E182ACE73889AEB1A6A352E@IRSMSX105.ger.corp.intel.com>
 <52D95CEA.809@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52D95CEA.809@profitbricks.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Friday, January 17, 2014 5:40 PM Sebastian Riemer <sebastian.riemer@profitbricks.com> wrote:
> On 17.01.2014 14:55, Dorau, Lukasz wrote:
> >
> > Some additional information:
> >
> > The loop 'for' in macro ' for_each_isci_host ' defined as
> (drivers/scsi/isci/host.h:313):
> >
> > #define for_each_isci_host(id, ihost, pdev) \
> >         for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
> >              id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
> >              ihost = to_pci_info(pdev)->hosts[++id])
> >
> > should be executed only for i = 0 and 1, because:
> > ARRAY_SIZE(to_pci_info(pdev)->hosts) = SCI_MAX_CONTROLLERS = 2
> >
> > but it was executed also for i=2 regardless the above loop's end condition.
> 
> to_pci_info() can return NULL in dev_get_drvdata(). The use of
> ARRAY_SIZE() is inappropriate.
> 
> #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr))
> 
> #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
> 
> #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
> 
> I would say that this was supposed to trigger a build error but it
> didn't and added 1 to the loop end condition.
> 
> Can you test putting SCI_MAX_CONTROLLERS to the loop end condition, please?
> 

Replacing 'ARRAY_SIZE(to_pci_info(pdev)->hosts)' with 'SCI_MAX_CONTROLLERS' in the definition of the ' for_each_isci_host ' macro does not help. I have checked it.
The following patch helps:
http://marc.info/?l=linux-scsi&m=138987823011697&w=2

Lukasz
