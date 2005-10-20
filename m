From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 11:29:09 -0400
Message-ID: <4357B7C5.9000709@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com> <4356B3D3.1010203@adaptec.com> <20051020141123.GA7119@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19854 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932183AbVJTP3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 11:29:21 -0400
In-Reply-To: <20051020141123.GA7119@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 10:11, Christoph Hellwig wrote:
> On Wed, Oct 19, 2005 at 05:00:03PM -0400, Luben Tuikov wrote:
> 
>>On 10/19/05 16:08, Moore, Eric Dean wrote:
>>
>>>Luben:  He is adding support for linkerrors and link/phy reset;
>>>these for for CSMI/SDI API.
>>>
>>>Can you in your driver retreive link errors for the links on the expanders?
>>
>>Yes. (offloaded to user space)
>>
>>You use the user space program called "expander_conf.c" to
>>send SMP requests and receive SMP responses.
> 
> 
> Yes, exactly.  On the other hand we don't have standard
> hardware-indepent ways of doing that for the PHYs of the HBA because
> the programming interfaces are to different and need to abstract it away
> in the kernel.

The _protocol_ way is SMP.  And LSI does implement SMP passthrough.

You have two scenarios: local phys and SMP.

Note that your task as wanted by HP/LSI/etc (all who use Fusion MPT)
is to implement SDI/CSMI, see http://www.t10.org/drafts.htm#sdi- .

If you implement this, as say, drivers/scsi/sdi.c, then I'd
be more than happy to register with it so as to export
SDI/CSMI functionality.

E.g. if you look at SDI_GET_PHY_INFO you will notice
that this is only for phys of the Host Adapter, NOT all
phys on the domain (which is a _crazy_ concept).

Most of the code has been written right in the SDI spec
sdi-r00.pdf.  You can start from there.  And most of the concepts
have been implemented in say LSI's FW and in my code, the SAS
Transport Layer.

E.g. you can see how "port identifier is u8" which is exactly
what, I'm sure, LSI's fw uses (or can fit in), and as you can see
in my code that I use (I actually use "int").

Now, _registration_ of SDI by different entities would be common,
say, sdi_register_provider(struct ...); Also the _mechanism_
to access that facility would be common*.  But _dispatching_
would be implementation dependent as you can see LSI would
do it differently and Adaptec would do it differently and
XYZ would do it differently, etc.

* I say common because you can use sg, in which case the
IOCTLs described in the spec are directly translated into
"headers" to be issued down sg.

Your task is clearly defined by a spec (sdi-r00.pdf).
Most of the functions defined therein are direct SAS concepts
and, as you can see, translate to an SMP function, or to a TMF,
since this is where they were taken from to begin with.

There is no need for translation layers upon translation
layers.  The task is clearly defined: LSI wants SDI/CSMI.
You have a CSMI spec.  Implement it.  This would make
everyone's job so much easier without destroying already
existing _good_ code.

>  That's why I need the local_attached flag as an internal
> helper - it's not actually exposed to userland so the implementation

1) LSI does have SMP pass through.
2) You absolutely do not need to represent all phys on the domain,
which is, as I said, a completely _crazy_ idea.  Look, even SDI doesn't
want you to do that.  What SDI wants you to do is issue SMP out.
LSI does have SMP pass through in FW so use that.
3) All you care about is SDI, and SDI has a _spec_.  Your job is
twofold:
	- implement drivers/scsi/sdi.c so we can all use it,
	- implement the implementation/hw dependent way to
	access SDI functionality for Fusion as described above
	where I mention that this would be implementation dependent
	(dispatching to).

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
