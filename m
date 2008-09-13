From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Fri, 12 Sep 2008 21:49:48 -0700
Message-ID: <20080913044948.GA31135@mail.oracle.com>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org> <20080910233107.GC23864@mail.oracle.com> <1221097366.27831.216.camel@haakon2.linux-iscsi.org> <20080911021331.GA12902@mail.oracle.com> <1221107358.27831.289.camel@haakon2.linux-iscsi.org> <20080911063846.GB16583@mail.oracle.com> <1221123529.27831.343.camel@haakon2.linux-iscsi.org> <20080912201541.GA26469@mail.oracle.com> <1221258477.3401.81.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:27820 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbYIMEuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Sep 2008 00:50:21 -0400
Content-Disposition: inline
In-Reply-To: <1221258477.3401.81.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Fri, Sep 12, 2008 at 03:27:57PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2008-09-12 at 13:15 -0700, Joel Becker wrote:
> > 	No, you don't do this.  Like I said, configfs clients let
> > userspace create and destroy items.  Not kernelspace.  Do not call
> > sys_mkdir()/sys_rmdir() from your modules.
> 
> Well, the startup 'fabric registration' is only case where I figured
> vfs_mkdir($CONFIGFS/target/$FABRIC) being called in order to have the
> fabric struct config_item appear at modprobe $FABRIC_MOD *BEFORE* the
> user did anything would be beneficial at all.   If vfs_mkdir() was not
> called from transport_fabric_register_configfs(), it only means user
> would have call mkdir $CONFIGFS/target/$FABRIC and/or mkdir -p
> $CONFIGFS/target/$FABRIC/endpoint to kick off one common make_group()
> for $FABRIC (that lives in target_core_configfs.c) and then make_group()
> that likes inside of $FABRIC_MOD who's parent is $CONFIGFS/target.  In
> LIO-Target's case, this would be creating a new iSCSI Qualified Name
> with mkdir $CONFIGFS/target/iscsi/iqn.superturobdiskarry

	I'm still totally unclear as to why $FABRIC has to live under
target/.  I'm not clear if there can be more than one $FABRIC at a time.
etc.  That's what I'm trying to understand so I can help you out.

Joel

-- 

Life's Little Instruction Book #20

	"Be forgiving of yourself and others."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
