From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 08:11:13 -0800
Message-ID: <1542125473.3042.6.camel@linux.vnet.ibm.com>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
         <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
         <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-11-13 at 16:53 +0100, Johannes Thumshirn wrote:
> On 13/11/2018 16:44, John Garry wrote:
> > On 13/11/2018 15:08, Sabyasachi Gupta wrote:
[...]
> > > -    fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages *
> > > PAGE_SIZE));
> > > +    fnic_trace_buf_p = (unsigned long)vzalloc((trace_max_pages *
> > > +                                PAGE_SIZE));
> > 
> > If you remove the extra brackets in vzalloc() argument then you may
> > not spill onto the next line.
> 
> And remove the unnecessary cast. vzalloc() (just like vmalloc())
> returns a void*, so no reason to cast it.

This is incorrect advice: there's no need to cast it to other *pointer*
types, but if you cast it to a non-pointer type (which this is doing)
the compiler will complain if there is no explicit cast.

James
