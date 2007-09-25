From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Tue, 25 Sep 2007 11:51:13 +0200
Message-ID: <46F8DA11.6030103@panasas.com>
References: <20070721203410.GA1004@havoc.gtf.org> <1189865576.3339.0.camel@localhost.localdomain> <46F85578.70503@garzik.org> <20070925082027.GA9587@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11745 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183AbXIYJvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 05:51:47 -0400
In-Reply-To: <20070925082027.GA9587@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Tue, Sep 25 2007 at 10:20 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Sep 24, 2007 at 08:25:28PM -0400, Jeff Garzik wrote:
>>> OK, we've had these competing patch sets floating around for two months
>>> now.  Christoph and Jeff, can we get agreement on which is going in?
>> Well, my opinion is
>>
>> 1) When judging by total amount of positive improvement, Christoph's 
>> patches are superior -- he has more overall cleanups than I do.
>>
>> 2) When judging by likelihood of inducing breakage, I feel my changes 
>> are superior.  My gdth changes tightly adhere to the 
>> equivalent-transformation method of shuffing code around, enabling 
>> further improvements.  IOW, I resisted the urge to make cleanups and fix 
>> insignificant, pre-existing bugs during the transformations.
>>
>> 3) I am utterly unmotivated to merge the two patchsets.  Someone should 
>> make an executive decision, pull one patchset, and drop the other.  My 
>> coding "mood" has swung from cleaning up code to writing new SAS drivers :)
> 
> Go ahead with your patches as I don't have time working on mine right now.
> I'll port them ontop of your patches when I get time for it.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have attempted a merge of both patchsets, and was about to send them
but found that some code must be moved to earlier patches if I want bisectability.
So it will take me another day to redo the patches and clean them up.

I have went even farther than Christoph with my patchset to totally 
remove the gdth_ctr_tab array and only use the new gdth_instances LIST_HEAD.
I have done that by simply passing gdth_ha_str pointers around instead of
hanum's.

On top of that I have my own agenda of cleaning the !use_sg code paths and getting
rid of scsi_cmnd abuse, so there is also that.

So the patchset certainly takes the "likelihood of inducing breakage" approach.
Being a merge of code from three people and none of them tested. So they will
have to be exercised on real hardware before inclusion. Is there someone, perhaps
in Adaptec, that can try some code.

Boaz

