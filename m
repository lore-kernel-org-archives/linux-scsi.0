From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] libsas: flush initial device discovery before
 completing ->scan_finished()
Date: Fri, 27 May 2011 23:33:45 -0700
Message-ID: <BANLkTinS08cRKiqVX6Hei+bJ4EX4hs4Qbg@mail.gmail.com>
References: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
	<20110524201748.7351.48220.stgit@localhost6.localdomain6>
	<BANLkTin8xQcyEiSa__+AfsV=T+NVRUwEhQ@mail.gmail.com>
	<1306552482.12244.23.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55893 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1E1Gdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 May 2011 02:33:46 -0400
In-Reply-To: <1306552482.12244.23.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, jacek.danecki@intel.com, jack_wang@usish.com, lindar_liu@usish.com, linux-ide@vger.kernel.org, David Milburn <dmilburn@redhat.com>, edmund.nadolski@intel.com, Srinivas <satyasrinivasp@hcl.in>

On Fri, May 27, 2011 at 8:14 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-05-27 at 17:41 -0700, Dan Williams wrote:
>> On Tue, May 24, 2011 at 1:17 PM, Dan Williams <dan.j.williams@intel.=
com> wrote:
>> > During initial scan libsas drivers start their phys and notify lib=
sas
>> > with PORTE_BYTES_DMAED events as port links are established. =A0Th=
is
>> > notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN e=
vents
>> > to the queue. =A0Calling scsi_flush_work() at the end of scan_fini=
shed
>> > guarantees that all preceding PORTE_BYTES_DMAED events have been
>> > registered in the queue, but it does not guarantee that the result=
ing
>> > DISCE_DISCOVER_DOMAIN events have been processed because
>> > flush_workqueue() explicitly avoids live-locking with incoming wor=
k.
>> >
>> > Introduce sas_flush_discovery() to guarantee that all initial disc=
overy
>> > events have completed. =A0It is called after the driver determines=
 all
>> > initial PORTE_BYTES_DMAED events have had a chance to enter the qu=
eue.
>> > This does not cover BCNs that are generated during expander bring =
up,
>> > only the initial sas_discover_domain() event.
>>
>> I notice that scsi-misc picked up all the patches from the series,
>> save this one.
>>
>> Oversight, or nak?
>
> Neither ... as I've said several times before, I want to use tejun's
> drain infrastructure for this.
>

Apologies, for the disconnect.

=46ound the drain_workqueue thread...

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
