From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH 3/7] fc class: Add support for new transport
	errors
Date: Tue, 19 Aug 2008 11:35:42 -0400
Message-ID: <48AAE84E.2030501@emulex.com>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>	<1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>	<1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ack.

Although, I have the personal style preference of :
   rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
                     FC_RPORT_DEVLOSS_PENDING);
over
  >
  > +	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
  >  	rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
  >

-- james s

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When we block a rport and the driver implements the terminate
> callback we will fail IO that was running quickly. However
> IO that was in the scsi_device/block queue sits there until
> the dev_loss_tmo fires, and this can make it look like IO is
> lost because new IO will get executed but that IO stuck in
> the blocked queue sits there for some time longer.
> 
> With this patch when the fast io fail tmo fires, we will
> fail the blocked IO and any new IO. This patch also allows
> all drivers to partially support the fast io fail tmo. If the
> terminate io callback is not implemented, we will still fail blocked
> IO and any new IO, so multipath can handle that. This means that for
> drivers like qla2xxx which seem to fail the IO when the error is first
> detected this will then allow drivers like lpfc and qla2xxx to have the
> IO flushed to the upper layers when the fast io fail tmo is fired.
> 
> This patch also allows the fc and iscsi classes to implement the
> same behavior. The timers are just unfornately named differently.
> 
> The next patches will convert the drivers to support this.
> 
> This patch has been lightly tested with lpfc and qla2xxx. I am not able
> to test the role change handling.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/scsi_transport_fc.c |   15 ++++++++++-----
>  include/scsi/scsi_transport_fc.h |    8 ++++++--
>  2 files changed, 16 insertions(+), 7 deletions(-)
