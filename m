From: Black_David@emc.com
Subject: RE: Thin provisioning & arrays
Date: Mon, 10 Nov 2008 20:23:17 -0500
Message-ID: <9FA859626025B64FBC2AF149D97C944A8A64B5@CORPUSMX80A.corp.emc.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org> <20081110221807.GI2373@disturbed>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20081110221807.GI2373@disturbed>
Sender: linux-fsdevel-owner@vger.kernel.org
To: david@fromorbit.com, dwmw2@infradead.org
Cc: martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx, Black_David@emc.com
List-Id: linux-scsi@vger.kernel.org

Dave,

> Treating it as a reliable command (i.e. it succeeds or returns
> an error) means that we can implement filesystems that can do
> unmapping in such a way that when the array reports that it is out
> of space we *know* that there is no free space that can be unmapped.
> i.e. no need for a "defrag" tool.

What if the filesystem block size and the array thin provisioning
chunk size don't match?  It's still "defrag" time ...

> So how do you propose that a storage architect who is trying to
> design a reliable thin provisioning storage stack finds out which
> devices actually do reliable unmapping? Vendors are simply going
> to say they support the unmap command, which currently means
> anything from "ignore completely" to "always do the right thing".

The thin provisioning chunk size (coming) in the VPD page is a
possible place to start.

Do you want something that says "if an aligned multiple of the chunk
size is sent in UNMAP, then it will be unmapped?".  That may be
plausible, but I don't want to hit an UNMAP that isn't an aligned
multiple with a CHECK CONDITION if there's something useful to do.

Thanks,
--David
