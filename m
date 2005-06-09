From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Thu, 09 Jun 2005 07:51:44 -0400
Message-ID: <1118317904.5043.3.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
	<1117901234.5005.9.camel@mulgrave> <1117955727.4961.8.camel@mina>
	<20050606190205.GA6817@us.ibm.com>
	<1118157976.42a5bc98d6f75@webmail.cs.wisc.edu>
	<20050607182317.GA12959@us.ibm.com> <42A711BC.9020108@cs.wisc.edu>
	<20050609000830.GA20616@us.ibm.com>  <20050609061838.GB5140@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050609061838.GB5140@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-06-09 at 08:18 +0200, Jens Axboe wrote:
> > So use a req->retries instead of the fail fast flag?
> 
> Would be fine. Some drivers are messing with ->errors for that anyways,
> so would be nice to clean that up.
> 
> It would need to be done _very_ carefully though!

Actually, I think there's still a need for both.  Fail fast implies more
than simply no retry.  In the SCSI case it should eventually mean fail
the command before we begin transport recovery (at the moment, we simply
use the command in transport recovery, however long it takes, and then
return the failure).

James
