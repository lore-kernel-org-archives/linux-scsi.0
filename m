From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: LSF: Multipathing and path checking question
Date: Mon, 20 Apr 2009 14:10:51 -0500
Message-ID: <49ECC8BB.9020906@cs.wisc.edu>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de>
	<49E89866.50205@cs.wisc.edu> <49EC2B65.1050508@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49EC2B65.1050508@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
>> Today, instead of #2, the Red Hat multipath tools guy and I were talking
>> about doing a probe with SG_IO. For example we would send down a path
>> tester IO and then wait for it to be failed with DID_TRANSPORT_FAILFAST.
>>
> No. this is exactly what you cannot do. SG_IO will be stalled when the
> sdev is BLOCKED and will only return a result _after_ the sdev transitions
> _out_ of the BLOCKED state.
> Translated to FC this means that whenever dev_loss_tmo is _active_ (!)
> no I/O will be send out neither any I/O result will be returned to userland.
> 

That is not true anymore. When fast io fail fires, the sdev and rport 
will be blocked, but the the fc class will call into the LLD to have it 
fail any IO still running in the driver. The FC class will then fail any 
IO in the block queues, and then it will also fail any new IO sent to it.

With your patch to have multipath-tools set fast io fail for multipath, 
then we should always get the IO failed before dev_loss_tmo fires.
