From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/4] scsi: ncr53c8xx: remove ScsiResult macro
Date: Mon, 9 Jul 2018 09:15:16 +0200
Message-ID: <20180709071516.oigjx5wetjqlvqpb@linux-x5ow.site>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-5-jthumshirn@suse.de>
 <a4a799f62ffa873fc3a7e23a5a46dafc8805b984.camel@wdc.com>
 <20180706080939.iotmgb24f6iaawkp@linux-x5ow.site>
 <ea39e5c6ff2b6081acd64cf14a0912e1510378a9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ea39e5c6ff2b6081acd64cf14a0912e1510378a9.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 06, 2018 at 05:05:19PM +0000, Bart Van Assche wrote:
> On Fri, 2018-07-06 at 10:09 +0200, Johannes Thumshirn wrote:
> > On Thu, Jul 05, 2018 at 05:04:05PM +0000, Bart Van Assche wrote:
> > > On Thu, 2018-07-05 at 13:01 +0200, Johannes Thumshirn wrote:
> > > > -		cmd->result = ScsiResult(DID_OK, S_CHECK_COND);
> > > > +		cmd->result = DID_OK << 16 | S_CHECK_COND;
> > > 
> > > Since DID_OK == 0, do we really need "DID_OK << 16 |" here?
> > 
> > Please see my answers to the other patches on this.
> 
> No matter what the next step is, you will have to deal with code that looks
> very similar to what I proposed. An example from libata:
> 
> 	else if (qc->flags & ATA_QCFLAG_SENSE_VALID)
> 		cmd->result = SAM_STAT_CHECK_CONDITION;

OK, I'll take remove the "| 0" parts.

> 
> BTW, in drivers/scsi/sym53c8xx_2/sym_defs.h there are definitions for synonyms
> of standard SCSI constants. I wouldn't mind if these synonyms would be removed:
> 
> #define	S_GOOD		SAM_STAT_GOOD
> #define	S_CHECK_COND	SAM_STAT_CHECK_CONDITION
> #define	S_COND_MET	SAM_STAT_CONDITION_MET
> #define	S_BUSY		SAM_STAT_BUSY
> #define	S_INT		SAM_STAT_INTERMEDIATE
> #define	S_INT_COND_MET	SAM_STAT_INTERMEDIATE_CONDITION_MET
> #define	S_CONFLICT	SAM_STAT_RESERVATION_CONFLICT
> #define	S_TERMINATED	SAM_STAT_COMMAND_TERMINATED
> #define	S_QUEUE_FULL	SAM_STAT_TASK_SET_FULL

Yup, saw those as well and already removed them in the next
version. Ditto for the bfa ones.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
