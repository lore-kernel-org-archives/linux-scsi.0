From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] fusion SAS support (mptsas driver)
Date: Thu, 15 Sep 2005 13:18:31 +0100
Message-ID: <20050915121831.GA26769@infradead.org>
References: <91888D455306F94EBD4D168954A9457C04079F2A@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12467 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751180AbVIOMSf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:18:35 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C04079F2A@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Sep 14, 2005 at 03:52:23PM -0600, Moore, Eric Dean wrote:
> On Friday, September 09, 2005 8:27 AM, Christoph Hellwig wrote:
> > 
> > Adds the actual mptsas driver, based upon the LSI driver with new work
> > for SAS transport class integration from Eric Moore and me.
> > 
> > This obviously depends on the SAS transport class.
> > 
> > 
> 
> I'm getting a oops when mptsas.ko loads. It appears to be
> in sas_host_setup() when dev_to_shost() is called.
> 
> I applied you're three patches to the current stream from last Friday, which
> at that time was 2.6.13 + 2.6.13-git-9.  Is that correct kernel
> I should be on? Or should it be something else?

Did you get any compile errors in scsi_transport_sas.c?  sas_host_setup
changed the prototype from

	static int sas_host_setup(struct device *dev)

to

	static int sas_host_setup(struct transport_container *tc,
		struct device *dev, struct class_device *cdev)

recently, and you're oops looks like you have a mismatch.
