From: Arun Easi <arun.easi@cavium.com>
Subject: Re: [PATCH 1/2] block: Implement global tagset
Date: Thu, 6 Apr 2017 23:21:05 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1704062308441.727@mvluser05.qlc.com>
References: <1491307665-47656-1-git-send-email-hare@suse.de> <1491307665-47656-2-git-send-email-hare@suse.de> <alpine.LRH.2.00.1704052257580.727@mvluser05.qlc.com> <b80f5b80-4b4f-279f-379e-c1d74be7fc7c@suse.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="487202828-1537813974-1491546074=:727"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b80f5b80-4b4f-279f-379e-c1d74be7fc7c@suse.com>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--487202828-1537813974-1491546074=:727
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Thu, 6 Apr 2017, 1:49am, Hannes Reinecke wrote:

> On 04/06/2017 08:27 AM, Arun Easi wrote:
> > Hi Hannes,
> > 
> > Thanks for taking a crack at the issue. My comments below..
> > 
> > On Tue, 4 Apr 2017, 5:07am, Hannes Reinecke wrote:
> > 
> >> Most legacy HBAs have a tagset per HBA, not per queue. To map
> >> these devices onto block-mq this patch implements a new tagset
> >> flag BLK_MQ_F_GLOBAL_TAGS, which will cause the tag allocator
> >> to use just one tagset for all hardware queues.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >> ---
> >>  block/blk-mq-tag.c     | 12 ++++++++----
> >>  block/blk-mq.c         | 10 ++++++++--
> >>  include/linux/blk-mq.h |  1 +
> >>  3 files changed, 17 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> >> index e48bc2c..a14e76c 100644
> >> --- a/block/blk-mq-tag.c
> >> +++ b/block/blk-mq-tag.c
> >> @@ -276,9 +276,11 @@ static void blk_mq_all_tag_busy_iter(struct blk_mq_tags *tags,
> >>  void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
> >>  		busy_tag_iter_fn *fn, void *priv)
> >>  {
> >> -	int i;
> >> +	int i, lim = tagset->nr_hw_queues;
> >>  
> >> -	for (i = 0; i < tagset->nr_hw_queues; i++) {
> >> +	if (tagset->flags & BLK_MQ_F_GLOBAL_TAGS)
> >> +		lim = 1;
> >> +	for (i = 0; i < lim; i++) {
> >>  		if (tagset->tags && tagset->tags[i])
> >>  			blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
> >>  	}
> >> @@ -287,12 +289,14 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
> >>  
> >>  int blk_mq_reinit_tagset(struct blk_mq_tag_set *set)
> >>  {
> >> -	int i, j, ret = 0;
> >> +	int i, j, ret = 0, lim = set->nr_hw_queues;
> >>  
> >>  	if (!set->ops->reinit_request)
> >>  		goto out;
> >>  
> >> -	for (i = 0; i < set->nr_hw_queues; i++) {
> >> +	if (set->flags & BLK_MQ_F_GLOBAL_TAGS)
> >> +		lim = 1;
> >> +	for (i = 0; i < lim; i++) {
> >>  		struct blk_mq_tags *tags = set->tags[i];
> >>  
> >>  		for (j = 0; j < tags->nr_tags; j++) {
> >> diff --git a/block/blk-mq.c b/block/blk-mq.c
> >> index 159187a..db96ed0 100644
> >> --- a/block/blk-mq.c
> >> +++ b/block/blk-mq.c
> >> @@ -2061,6 +2061,10 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
> >>  {
> >>  	int ret = 0;
> >>  
> >> +	if ((set->flags & BLK_MQ_F_GLOBAL_TAGS) && hctx_idx != 0) {
> >> +		set->tags[hctx_idx] = set->tags[0];
> >> +		return true;
> >> +	}
> > 
:
> 
> > BTW, if you would like me to try out this patch on my setup, please let me 
> > know.
> > 
> Oh, yes. Please do.
> 

Ran the tests on my setup (Dell R730, 2 Node). This change did not drop 
any IOPs (got ~2M 512b). The cache miss percentage was varying based on if 
the tests were running on one node or both (latter yperformed worse). All 
interrupts were directed to only 1 node. Interestingly, the cache miss 
percentage was lowest when MQ was off.

I hit a fdisk hang (open path), btw, not sure if it has anything todo with 
this change, though.

Notes and hang stack attached.

Let me know if you are interested in any specific perf event/command-line.

Regards,
-Arun
--487202828-1537813974-1491546074=:727
Content-Type: TEXT/plain; name=NEW-BLK-MQ-notes.txt
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LRH.2.00.1704062321050.727@mvluser05.qlc.com>
Content-Description: 
Content-Disposition: attachment; filename=NEW-BLK-MQ-notes.txt

cGVyZiBzdGF0LCByYW4gb24gYSBzaG9ydCAxMCBzZWNvbmQgbG9hZC4NCg0K
LS0tMXBvcnQtMW5vZGUtbmV3LW1xLS0tLQ0KIFBlcmZvcm1hbmNlIGNvdW50
ZXIgc3RhdHMgZm9yICdDUFUocykgMic6DQoNCiAxODgsNjQyLDY5NiAgICAg
IExMQy1sb2FkcyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKDY2LjY2JSkNCiAgIDMsNjE1LDE0MiAgICAgIExMQy1sb2Fk
LW1pc3NlcyAgIyAgICAxLjkyJSBvZiBhbGwgTEwtY2FjaGUgaGl0cyAgICAg
KDY2LjY3JSkNCiAgODYsNDg4LDM0MSAgICAgIExMQy1zdG9yZXMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKDMzLjM0JSkN
CiAgMTAsODIwLDk3NyAgICAgIExMQy1zdG9yZS1taXNzZXMgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKDMzLjMzJSkNCiAzOTEsMzcw
LDEwNCAgICAgIGNhY2hlLXJlZmVyZW5jZXMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKDQ5Ljk5JSkNCiAgMTQsNDk4LDQ5MSAgICAg
IGNhY2hlLW1pc3NlcyAgICAgIyAgICAzLjcwNSAlIG9mIGFsbCBjYWNoZSBy
ZWZzICAgICAgKDY2LjY2JSkNCg0KLS0tMXBvcnQtMW5vZGUtbXEtLS0NCiBQ
ZXJmb3JtYW5jZSBjb3VudGVyIHN0YXRzIGZvciAnQ1BVKHMpIDInOg0KDQog
MTQ1LDAyNSw5OTkgICAgICBMTEMtbG9hZHMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICg2Ni42NyUpDQogICAzLDc5Myw0
MjcgICAgICBMTEMtbG9hZC1taXNzZXMgICMgICAgMi42MiUgb2YgYWxsIExM
LWNhY2hlIGhpdHMgICAgICg2Ni42NyUpDQogIDYwLDg3OCw5MzkgICAgICBM
TEMtc3RvcmVzICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICgzMy4zMyUpDQogICA4LDA0NCw3MTQgICAgICBMTEMtc3RvcmUt
bWlzc2VzICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICgz
My4zMyUpDQogMjk0LDcxMywwNzAgICAgICBjYWNoZS1yZWZlcmVuY2VzICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICg1MC4wMCUpDQog
IDExLDkyMywzNTQgICAgICBjYWNoZS1taXNzZXMgICAgICMgICAgNC4wNDYg
JSBvZiBhbGwgY2FjaGUgcmVmcyAgICAgICg2Ni42NiUpDQoNCi0tLTFwb3J0
LTFub2RlLW5vbXEtLS0NCiBQZXJmb3JtYW5jZSBjb3VudGVyIHN0YXRzIGZv
ciAnQ1BVKHMpIDInOg0KDQogMTU3LDM3NSw3MDkgICAgICBMTEMtbG9hZHMg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICg2
Ni42NiUpDQogICAgIDQ3NiwxMTcgICAgICBMTEMtbG9hZC1taXNzZXMgICMg
ICAgMC4zMCUgb2YgYWxsIExMLWNhY2hlIGhpdHMgICAgICg2Ni42NiUpDQog
IDc2LDA0NiwwOTggICAgICBMTEMtc3RvcmVzICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICgzMy4zNCUpDQogICAgIDg0MCw3
NTYgICAgICBMTEMtc3RvcmUtbWlzc2VzICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICgzMy4zNCUpDQogMzI2LDIzMCw5NjkgICAgICBj
YWNoZS1yZWZlcmVuY2VzICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICg1MC4wMCUpDQogICAxLDMzMiwzOTggICAgICBjYWNoZS1taXNz
ZXMgICAgICMgICAgMC40MDggJSBvZiBhbGwgY2FjaGUgcmVmcyAgICAgICg2
Ni42NyUpDQoNCj09PT09PT09PT09PT09PT09PT09PT0NCg0KLS0ycG9ydC1h
bGxub2Rlcy1uZXctbXEtLQ0KIFBlcmZvcm1hbmNlIGNvdW50ZXIgc3RhdHMg
Zm9yICdDUFUocykgMic6DQoNCiAgNTUsNDU1LDUzMyAgICAgIExMQy1sb2Fk
cyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KDY2LjY3JSkNCiAgMzcsOTk2LDU0NSAgICAgIExMQy1sb2FkLW1pc3NlcyAg
IyAgIDY4LjUyJSBvZiBhbGwgTEwtY2FjaGUgaGl0cyAgICAgKDY2LjY3JSkN
CiAgMTQsMDMwLDI5MSAgICAgIExMQy1zdG9yZXMgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKDMzLjMzJSkNCiAgIDcsMDk2
LDkzMSAgICAgIExMQy1zdG9yZS1taXNzZXMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKDMzLjMzJSkNCiAgNzYsNzExLDE5NyAgICAg
IGNhY2hlLXJlZmVyZW5jZXMgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKDQ5Ljk5JSkNCiAgNDUsMTcwLDcxOSAgICAgIGNhY2hlLW1p
c3NlcyAgICAgIyAgIDU4Ljg4NCAlIG9mIGFsbCBjYWNoZSByZWZzICAgICAg
KDY2LjY2JSkNCg0KLS0ycG9ydC1hbGxub2Rlcy1tcS0tDQogUGVyZm9ybWFu
Y2UgY291bnRlciBzdGF0cyBmb3IgJ0NQVShzKSAyJzoNCg0KICA1OSwzMDMs
NDEwICAgICAgTExDLWxvYWRzICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAoNjYuNjYlKQ0KICAzMSwxMTUsNjAxICAgICAg
TExDLWxvYWQtbWlzc2VzICAjICAgNTIuNDclIG9mIGFsbCBMTC1jYWNoZSBo
aXRzICAgICAoNjYuNjYlKQ0KICAxNyw0OTYsNDc3ICAgICAgTExDLXN0b3Jl
cyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAo
MzMuMzQlKQ0KICAgNiwyMDEsMzczICAgICAgTExDLXN0b3JlLW1pc3NlcyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAoMzMuMzQlKQ0K
ICA4OSwwMzUsMjcyICAgICAgY2FjaGUtcmVmZXJlbmNlcyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAoNTAuMDAlKQ0KICAzNywzNzIs
Nzc3ICAgICAgY2FjaGUtbWlzc2VzICAgICAjICAgNDEuOTc1ICUgb2YgYWxs
IGNhY2hlIHJlZnMgICAgICAoNjYuNjYlKQ0KDQotLTJwb3J0LWFsbG5vZGVz
LW5vbXEtLQ0KIFBlcmZvcm1hbmNlIGNvdW50ZXIgc3RhdHMgZm9yICdDUFUo
cykgMic6DQoNCiAgODYsNzI0LDkwNSAgICAgIExMQy1sb2FkcyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKDY2LjY3JSkN
CiAgMjcsMTU0LDI0NSAgICAgIExMQy1sb2FkLW1pc3NlcyAgIyAgIDMxLjMx
JSBvZiBhbGwgTEwtY2FjaGUgaGl0cyAgICAgKDY2LjY3JSkNCiAgMzMsNzEw
LDI2NSAgICAgIExMQy1zdG9yZXMgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKDMzLjM0JSkNCiAgIDYsNTIxLDM5NCAgICAg
IExMQy1zdG9yZS1taXNzZXMgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKDMzLjMzJSkNCiAxMzksMDg5LDUyOCAgICAgIGNhY2hlLXJl
ZmVyZW5jZXMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KDUwLjAwJSkNCiAgMzMsNjgyLDAwMCAgICAgIGNhY2hlLW1pc3NlcyAgICAg
IyAgIDI0LjIxNiAlIG9mIGFsbCBjYWNoZSByZWZzICAgICAgKDY2LjY2JSkN
Cg0K

--487202828-1537813974-1491546074=:727
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=new_blk_fdisk_hang.out
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LRH.2.00.1704062321051.727@mvluser05.qlc.com>
Content-Description: 
Content-Disposition: attachment; filename=new_blk_fdisk_hang.out

DQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogSU5GTzogdGFz
ayBmZGlzazoyNzc0NSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29u
ZHMuDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogICAgICBU
YWludGVkOiBHICAgIEIgICAgICBPRSAgIDQuMTEuMC1yYzQtbmV3YmxrLWFl
KyAjNA0KQXByICA2IDE3OjM0OjA1IGF2bG54cGVyZiBrZXJuZWw6ICJlY2hv
IDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0X3NlY3Mi
IGRpc2FibGVzIHRoaXMgbWVzc2FnZS4NCkFwciAgNiAxNzozNDowNSBhdmxu
eHBlcmYga2VybmVsOiBmZGlzayAgICAgICAgICAgRCAgICAwIDI3NzQ1ICAy
Nzc0MyAweDAwMDAwMDgwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtl
cm5lbDogQ2FsbCBUcmFjZToNCkFwciAgNiAxNzozNDowNSBhdmxueHBlcmYg
a2VybmVsOiBfX3NjaGVkdWxlKzB4Mjg5LzB4OGYwDQpBcHIgIDYgMTc6MzQ6
MDUgYXZsbnhwZXJmIGtlcm5lbDogc2NoZWR1bGUrMHgzNi8weDgwDQpBcHIg
IDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogc2NoZWR1bGVfdGltZW91
dCsweDI0OS8weDMwMA0KQXByICA2IDE3OjM0OjA1IGF2bG54cGVyZiBrZXJu
ZWw6ID8gc2NoZWRfY2xvY2tfY3B1KzB4MTEvMHhiMA0KQXByICA2IDE3OjM0
OjA1IGF2bG54cGVyZiBrZXJuZWw6ID8gdHJ5X3RvX3dha2VfdXArMHg1OS8w
eDQ1MA0KQXByICA2IDE3OjM0OjA1IGF2bG54cGVyZiBrZXJuZWw6IHdhaXRf
Zm9yX2NvbXBsZXRpb24rMHgxMjEvMHgxODANCkFwciAgNiAxNzozNDowNSBh
dmxueHBlcmYga2VybmVsOiA/IHdha2VfdXBfcSsweDgwLzB4ODANCkFwciAg
NiAxNzozNDowNSBhdmxueHBlcmYga2VybmVsOiBmbHVzaF93b3JrKzB4MTFk
LzB4MWMwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogPyB3
YWtlX3VwX3dvcmtlcisweDMwLzB4MzANCkFwciAgNiAxNzozNDowNSBhdmxu
eHBlcmYga2VybmVsOiBfX2NhbmNlbF93b3JrX3RpbWVyKzB4MTBlLzB4MWQw
DQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogPyBrb2JqX2xv
b2t1cCsweDEwZC8weDE2MA0KQXByICA2IDE3OjM0OjA1IGF2bG54cGVyZiBr
ZXJuZWw6IGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYysweDEzLzB4MjANCkFw
ciAgNiAxNzozNDowNSBhdmxueHBlcmYga2VybmVsOiBkaXNrX2Jsb2NrX2V2
ZW50cysweDc3LzB4ODANCkFwciAgNiAxNzozNDowNSBhdmxueHBlcmYga2Vy
bmVsOiBfX2Jsa2Rldl9nZXQrMHgxMWIvMHg0YjANCkFwciAgNiAxNzozNDow
NSBhdmxueHBlcmYga2VybmVsOiBibGtkZXZfZ2V0KzB4MWMzLzB4MzIwDQpB
cHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogYmxrZGV2X29wZW4r
MHg1Yi8weDcwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDog
ZG9fZGVudHJ5X29wZW4rMHgyMTMvMHgzMzANCkFwciAgNiAxNzozNDowNSBh
dmxueHBlcmYga2VybmVsOiA/IGJkX2FjcXVpcmUrMHhkMC8weGQwDQpBcHIg
IDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogdmZzX29wZW4rMHg0Zi8w
eDcwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogPyBtYXlf
b3BlbisweDliLzB4MTAwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtl
cm5lbDogcGF0aF9vcGVuYXQrMHg1NTcvMHgxM2MwDQpBcHIgIDYgMTc6MzQ6
MDUgYXZsbnhwZXJmIGtlcm5lbDogPyBnZW5lcmljX2ZpbGVfcmVhZF9pdGVy
KzB4NzQ2LzB4OGMwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5l
bDogPyBzY3NpX2Jpb3NfcHRhYmxlKzB4NTQvMHgxMzANCkFwciAgNiAxNzoz
NDowNSBhdmxueHBlcmYga2VybmVsOiBkb19maWxwX29wZW4rMHg5MS8weDEw
MA0KQXByICA2IDE3OjM0OjA1IGF2bG54cGVyZiBrZXJuZWw6ID8gX19hbGxv
Y19mZCsweDQ2LzB4MTcwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtl
cm5lbDogZG9fc3lzX29wZW4rMHgxMjQvMHgyMTANCkFwciAgNiAxNzozNDow
NSBhdmxueHBlcmYga2VybmVsOiA/IF9fYXVkaXRfc3lzY2FsbF9leGl0KzB4
MjA5LzB4MjkwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDog
U3lTX29wZW4rMHgxZS8weDIwDQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJm
IGtlcm5lbDogZG9fc3lzY2FsbF82NCsweDY3LzB4MTgwDQpBcHIgIDYgMTc6
MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogZW50cnlfU1lTQ0FMTDY0X3Nsb3df
cGF0aCsweDI1LzB4MjUNCkFwciAgNiAxNzozNDowNSBhdmxueHBlcmYga2Vy
bmVsOiBSSVA6IDAwMzM6MHg3ZmFlZjg2YjBhMTANCkFwciAgNiAxNzozNDow
NSBhdmxueHBlcmYga2VybmVsOiBSU1A6IDAwMmI6MDAwMDdmZmZhNzE1OTQz
OCBFRkxBR1M6IDAwMDAwMjQ2IE9SSUdfUkFYOiAwMDAwMDAwMDAwMDAwMDAy
DQpBcHIgIDYgMTc6MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogUkFYOiBmZmZm
ZmZmZmZmZmZmZmRhIFJCWDogMDAwMDAwMDAwMGIzNDMxMCBSQ1g6IDAwMDA3
ZmFlZjg2YjBhMTANCkFwciAgNiAxNzozNDowNSBhdmxueHBlcmYga2VybmVs
OiBSRFg6IDAwMDA3ZmZmYTcxNTk1OTggUlNJOiAwMDAwMDAwMDAwMDgwMDAw
IFJESTogMDAwMDdmZmZhNzE1OTU5MA0KQXByICA2IDE3OjM0OjA1IGF2bG54
cGVyZiBrZXJuZWw6IFJCUDogMDAwMDdmZmZhNzE1OTU5MCBSMDg6IDAwMDA3
ZmFlZjg2MTA5MzggUjA5OiAwMDAwMDAwMDAwMDAwMDA4DQpBcHIgIDYgMTc6
MzQ6MDUgYXZsbnhwZXJmIGtlcm5lbDogUjEwOiAwMDAwMDAwMDAwMDAwMDAz
IFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAwMDAwMDAwMDAwMDAwMDAN
CkFwciAgNiAxNzozNDowNSBhdmxueHBlcmYga2VybmVsOiBSMTM6IDAwMDAw
MDAwMDBiMzQ1NTAgUjE0OiAwMDAwMDAwMDAwMDAwMDA1IFIxNTogMDAwMDAw
MDAwMDAwMDAwMA0K

--487202828-1537813974-1491546074=:727--
