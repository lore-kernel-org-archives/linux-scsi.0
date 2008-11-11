From: Dave Chinner <david@fromorbit.com>
Subject: Re: Thin provisioning & arrays
Date: Wed, 12 Nov 2008 09:49:58 +1100
Message-ID: <20081111224958.GL2373@disturbed>
References: <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org> <20081110221807.GI2373@disturbed> <9FA859626025B64FBC2AF149D97C944A8A64B5@CORPUSMX80A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:16515 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYKKWuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 17:50:04 -0500
Content-Disposition: inline
In-Reply-To: <9FA859626025B64FBC2AF149D97C944A8A64B5@CORPUSMX80A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Black_David@emc.com
Cc: dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

On Mon, Nov 10, 2008 at 08:23:17PM -0500, Black_David@emc.com wrote:
> Dave,
> 
> > Treating it as a reliable command (i.e. it succeeds or returns
> > an error) means that we can implement filesystems that can do
> > unmapping in such a way that when the array reports that it is out
> > of space we *know* that there is no free space that can be unmapped.
> > i.e. no need for a "defrag" tool.
> 
> What if the filesystem block size and the array thin provisioning
> chunk size don't match?  It's still "defrag" time ...

No, it's "fix the array implementation" time ;)

It seems the point that we've made that the higher layers can be
exact and robust is being ignored because it means work to make the
arrays exact and robust.

Following that, if the array is not robust (i.e. doesn't execute
unmap commands exactly as specified), then as a filesystem
developer I want to know that this occurred so that appropriate
warnings can be issued to inform the admin of what they need to
do when the array runs out of space....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
