From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: linux-next: Tree for Aug 1
Date: Thu, 2 Aug 2018 16:40:10 +0000
Message-ID: <9329f50c734eec5fa994ea652890f017a88625c2.camel@wdc.com>
References: <20180801175852.36549130@canb.auug.org.au>
         <20180801224813.GA13074@roeck-us.net>
         <1533163965.3158.1.camel@HansenPartnership.com>
         <20180801234727.GA3762@roeck-us.net>
         <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
         <1533168205.3158.12.camel@HansenPartnership.com>
         <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
         <CACVXFVMT7UwWHPQ6K-eNWZJOoZ77==Ki7zmX5UtDz4ZQFFB0Jw@mail.gmail.com>
         <a10a509a-7e5c-1706-52ee-79849cad4224@roeck-us.net>
         <20180802162654.GA8928@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802162654.GA8928@ming.t460p>
Content-Language: en-US
Content-ID: <F31844CD68AA864392DEFCF316450956@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux@roeck-us.net" <linux@roeck-us.net>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "josef@toxicpanda.com" <josef@toxicpanda.com>, "tj@kernel.org" <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-08-03 at 00:27 +-0800, Ming Lei wrote:
+AD4- This issue can be fixed by reverting d250bf4e776ff09d5 (+ACI-blk-mq: =
only iterate over
+AD4- inflight requests in blk+AF8-mq+AF8-tagset+AF8-busy+AF8-iter+ACI-).
+AD4-=20
+AD4- This patch looks wrong, because 'blk+AF8-mq+AF8-rq+AF8-state(rq) +AD0=
APQ- MQ+AF8-RQ+AF8-IN+AF8-FLIGHT'
+AD4- isn't completely same with 'blk+AF8-mq+AF8-request+AF8-started(req)'.

Please test the following change instead of reverting the commit mentioned
above:

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 09b2ee6694fb..25a0583d8b4c 100644
--- a/block/blk-mq-tag.c
+-+-+- b/block/blk-mq-tag.c
+AEAAQA- -271,7 +-271,7 +AEAAQA- static bool bt+AF8-tags+AF8-iter(struct sb=
itmap +ACo-bitmap, unsigned int bitnr, void +ACo-data)
 	 +ACo- test and set the bit before assining -+AD4-rqs+AFsAXQ-.
 	 +ACo-/
 	rq +AD0- tags-+AD4-rqs+AFs-bitnr+AF0AOw-
-	if (rq +ACYAJg- blk+AF8-mq+AF8-rq+AF8-state(rq) +AD0APQ- MQ+AF8-RQ+AF8-IN=
+AF8-FLIGHT)
+-	if (rq +ACYAJg- blk+AF8-mq+AF8-rq+AF8-state(rq) +ACEAPQ- MQ+AF8-RQ+AF8-I=
DLE)
 		iter+AF8-data-+AD4-fn(rq, iter+AF8-data-+AD4-data, reserved)+ADs-
=20
 	return true+ADs-

Thanks,

Bart.
