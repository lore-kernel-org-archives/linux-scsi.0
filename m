From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Thu, 3 Nov 2016 18:42:50 +0100
Message-ID: <20161103174250.ury2u5zbyi2tfyvt@linux-x5ow.site>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
 <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
 <20161103151751.GD7404@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161103151751.GD7404@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 03, 2016 at 08:17:51AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 14, 2016 at 09:38:21AM +0200, Johannes Thumshirn wrote:
> > On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
> > > Hm, still behaves for me like I reported for v2:
> > > http://marc.info/?l=linux-scsi&m=147637177902937&w=2
> > 
> > Hi Steffen,
> > 
> > Can you please try the following on top of 2/16?
> 
> How does this fit into the patch we're replying to?

Sorry but I don't quite get you.

If you look at a mixed source assembly listing for fc_host_dispatch() [1] we load
the the offset of 24 from %r12 into %r1 and then the beginning of %r1 into %r2
and crash. So if we now check if  job->request_len is smaller than uint32_t we
know we can't have a messagecode in the request and bail out early, instead of
accessing a possible NULL pointer. At least that's my analysis, feel free to
correct me if I'm wrong.

[1] Listing:
static int fc_bsg_host_dispatch(struct Scsi_Host *shost, struct bsg_job *job)
{
        struct fc_internal *i = to_fc_internal(shost->transportt);
        struct fc_bsg_request *bsg_request = job->request;
    5d54:       e3 10 c0 18 00 04       lg      %r1,24(%r12)
        struct fc_bsg_reply *bsg_reply = job->reply;
    5d5a:       e3 b0 c0 20 00 04       lg      %r11,32(%r12)
        int cmdlen = sizeof(uint32_t);  /* start with length of msgcode */
        int ret;

        /* check if we really have all the request data needed */
        if (job->request_len < cmdlen) {
    5d60:       a7 c4 00 48             jle     5df0 <fc_bsg_dispatch+0x1f0>
                ret = -ENOMSG;
                goto fail_host_msg;
        }

        /* Validate the host command */
        switch (bsg_request->msgcode) {
    5d64:       58 20 10 00             l       %r2,0(%r1)
    5d68:       c2 2f 80 00 00 03       clfi    %r2,2147483651
    5d6e:       a7 84 00 1a             je      5da2 <fc_bsg_dispatch+0x1a2>
    5d72:       a7 24 00 0a             jh      5d86 <fc_bsg_dispatch+0x186>
    5d76:       c0 19 80 00 00 01       iilf    %r1,2147483649
    5d7c:       ec 21 00 2b a0 77       clrj    %r2,%r1,10,5dd2 <fc_bsg_dispatch+0x1d2>
    5d82:       a7 f4 00 3b             j       5df8 <fc_bsg_dispatch+0x1f8>
    5d86:       c0 59 80 00 00 04       iilf    %r5,2147483652
    5d8c:       ec 25 00 0b 80 76       crj     %r2,%r5,8,5da2 <fc_bsg_dispatch+0x1a2>
    5d92:       c0 59 80 00 00 ff       iilf    %r5,2147483903
    5d98:       ec 25 00 13 80 76       crj     %r2,%r5,8,5dbe <fc_bsg_dispatch+0x1be>
    5d9e:       a7 f4 00 2d             j       5df8 <fc_bsg_dispatch+0x1f8>


Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
