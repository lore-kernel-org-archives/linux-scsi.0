From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH V5 10/16] s390: zfcp_fc: use sg helper to operate
 scatterlist
Date: Wed, 26 Jun 2019 10:17:33 +0200
Message-ID: <1353d755-de62-d575-4c7b-d20d59d07f23@linux.ibm.com>
References: <20190618013757.22401-1-ming.lei@redhat.com>
 <20190618013757.22401-11-ming.lei@redhat.com>
 <95bfa1fb-d0eb-fc61-ecc0-001ae52a326f@linux.ibm.com>
 <20190625011902.GA23777@ming.t460p>
 <93d3d89e-a9ae-691f-d1f8-0463f714957d@linux.ibm.com>
 <20190626030751.GA26340@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190626030751.GA26340@ming.t460p>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Finn Thain <fthain@telegraphics.com.au>, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, "Juergen E . Fischer" <fischer@norbit.de>, Dan Carpenter <dan.carpenter@oracle.com>, Benjamin Block <bblock@linux.ibm.com>, Brian King <brking@us.ibm.com>, Michael Schmitz <schmitzmic@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Ming,

On 6/26/19 5:07 AM, Ming Lei wrote:
> On Tue, Jun 25, 2019 at 12:51:04PM +0200, Steffen Maier wrote:
>> I don't mind doing this change for zfcp. However, I'm having doubts
>> regarding the rationale in the commit description.

> However, I still suggest to do it because it will make us to audit SCSI chained
> sg uses much easier. And the change shouldn't have performance effect.

>> If I was not mistaken above, the following could be more descriptive parts
>> of a patch/commit description, with hopefully less confusion for anyone
>> having to look at zfcp git history a few weeks/months/years from now:
>>
>> "While not required for this SCSI MQ change regarding scatterlist
>> allocation, change all other scatterlist iterators in zfcp to the safe
>> sg_next() even if not necessary as these changed zfcp-internal scatterlists
>> are linear and unchained. This may avoid confusion about a potential need
>> for conversions in the future."

Sure, let's change the code, but could you please update the description of 
your below new patch to something like I drafted above regarding rationale?

If you would like to send a V2, I'll be happy to give a Reviewed-by.

>>>   From c9c368308fefbf034d670984fe9746a4181fe514 Mon Sep 17 00:00:00 2001
>>> From: Ming Lei <ming.lei@redhat.com>
>>> Date: Tue, 25 Jun 2019 09:15:34 +0800
>>> Subject: [PATCH] s390: scsi: use sg helper to iterate over scatterlist

>>> Unlike the legacy I/O path, scsi-mq preallocates a large array to hold
>>> the scatterlist for each request. This static allocation can consume
>>> substantial amounts of memory on modern controllers which support a
>>> large number of concurrently outstanding requests.

>>> To facilitate a switch to a smaller static allocation combined with a
>>> dynamic allocation for requests that need it, we need to make sure all
>>> SCSI drivers handle chained scatterlists correctly.

>>> Convert remaining drivers that directly dereference the scatterlist
>>> array to using the iterator functions.

> OK, I still suggest to apply the patch for the mentioned reason if you
> are fine.



-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
