From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Tue, 11 Apr 2017 17:51:33 +0000
Message-ID: <1491933092.2654.10.camel@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
         <20170407181654.27836-7-bart.vanassche@sandisk.com>
         <20170411160958.GA19222@redhat.com> <1491928005.2654.6.camel@sandisk.com>
         <20170411174739.GA19620@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170411174739.GA19620@redhat.com>
Content-Language: en-US
Content-ID: <01DFD3EBB9073F4DB187C560929950BA@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-11 at 13:47 -0400, Mike Snitzer wrote:
> Other drivers will very likely be caught about by
> this blk-mq quirk in the future.

Hello Mike,

Are you aware that the requirement that blk-mq drivers rerun the queue afte=
r
having returned BLK_MQ_RQ_QUEUE_BUSY is a requirement that is shared with
traditional block drivers? From dm_old_request_fn():

	if (... ||=A0(ti->type->busy && ti->type->busy(ti))) {
		blk_delay_queue(q, 10);
		return;
	}

Bart.=
