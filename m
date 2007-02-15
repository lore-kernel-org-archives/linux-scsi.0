From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: BUG in libata from ata_sas_port_alloc
Date: Thu, 15 Feb 2007 15:54:41 -0800
Message-ID: <45D4F2C1.4050306@us.ibm.com>
References: <1171575405.3412.45.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1171575405.3412.45.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:

> The problem is that memory obtained by devm_kzalloc() cannot be returned
> by kfree() ... they come from different allocation lists.  The solution
> is probably to have a corresponding ata_probe_ent_free(), I just don't
> exactly see how to tell if the object came from the devm_kzalloc or not
> (unless it gets marked).

Just a shot in the dark, but could we simply make whatever changes are
necessary to make all sas-ata LLDDs managed and then use devm_kzalloc?
Though (and I may be totally wrong here) if it's the case that
devres_head is made (or not made) to be part of a list _only_ before we
reach ata_probe_ent_alloc, we could put a similar if check into the free
function.

--D
