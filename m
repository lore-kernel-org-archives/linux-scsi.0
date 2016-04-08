From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [dm-devel] [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Fri, 08 Apr 2016 13:42:16 +0200
Message-ID: <2760420.6GyDefUaH5@c203>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com> <57067597.4080103@suse.de> <20160407153448.GA30510@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194AbcDHLmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 07:42:19 -0400
In-Reply-To: <20160407153448.GA30510@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, jmoyer@redhat.com, linux-block@vger.kernel.org, j-nomura@ce.jp.nec.com

Ladies and Gentlemen,
To show off some numbers from our testing:

All tests are performed against the cache of the Array, not the disks a=
s we=20
wanted to test the Linux stack not the Disk Array.

All single queue tests have been performed with the deadline I/O Schedu=
ler.

Comments welcome, have fun reading :-)

QLogic 32GBit FC HBA NetApp EF560 Array w/ DM MQ this patchset:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
Random Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 785136 | 3066.1MB/s |
8k   | 734983 | 5742.6MB/s |
16k | 398516 | 6226.9MB/s |
32k | 200589 | 6268.5MB/s |
64k | 100417 | 6276.2MB/s |

Sequential Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 788620 | 3080.6MB/s |
8k   | 736359 | 5752.9MB/s |
16k | 398597 | 6228.8MB/s |
32k |  200487| 6265.3MB/s |
64k | 100402 | 6275.2MB/s |

Random Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 242105 | 968423KB/s |
8k   | 222290 | 1736.7MB/s |
16k | 178191 | 2784.3MB/s |
32k | 133619 | 4175.7MB/s |
64k |   97693 | 6105.9MB/s |

Sequential Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 134788 | 539155KB/s |
8k   | 132361 | 1034.8MB/s |
16k | 129941 | 2030.4MB/s |
32k | 128288 | 4009.4MB/s |
64k |   97776 | 6111.0MB/s |

QLogic 32GBit FC HBA NetApp EF560 Array w/ DM SQ this patchset:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
Random Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 112402 | 449608KB/s |
8k   | 112818 | 902551KB/s |
16k | 111885 | 1748.3MB/s |
32k | 188015 | 5875.6MB/s |
64k |   99021 |  6188.9MB/s |

Sequential Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 115046 | 460186KB/s |
8k   | 113974 | 911799KB/s |
16k | 113374 | 1771.5MB/s |
32k | 192932 | 6029.2MB/s |
64k | 100474 | 6279.7MB/s |

Random Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 114284 | 457138KB/s |
8k   | 113992 | 911944KB/s |
16k | 113715 | 1776.9MB/s |
32k | 130402 | 4075.9MB/s |
64k |   92243 | 5765.3MB/s |

Sequential Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 115540 | 462162KB/s |
8k   | 114243 | 913951KB/s |
16k | 300153 | 4689.1MB/s |
32k | 141069 | 4408.5MB/s |
64k |   97620 | 6101.3MB/s |


QLogic 32GBit FC HBA NetApp EF560 Array w/ DM MQ previous patchset:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Random Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 782733 | 3057.6MB/s |
8k   | 732143 | 5719.9MB/s |
16k | 398314 | 6223.7MB/s |
32k | 200538 | 6266.9MB/s |
64k | 100422 | 6276.5MB/s |

Sequential Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 786707 | 3073.8MB/s |
8k   | 730579 | 5707.7MB/s |
16k | 398799 | 6231.3MB/s |
32k | 200518 | 6266.2MB/s |
64k | 100397 | 6274.9MB/s |

Random Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 242426 | 969707KB/s |
8k   | 223079 | 1742.9MB/s |
16k | 177889 | 2779.6MB/s |
32k | 133637 | 4176.2MB/s |
64k |   97727 | 6107.1MB/s |

Sequential Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 134360 | 537442KB/s |
8k   | 129738 | 1013.6MB/s |
16k | 129746 | 2027.3MB/s |
32k | 127875 | 3996.1MB/s |
64k |   97683 | 6105.3MB/s |

Emulex 16GBit FC HBA NetApp EF560 Array w/ DM MQ this patchset :
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
[Beware, this is with Hannes' lockless lpfc patches, which are not upst=
ream as=20
they're quite experimental, but are good at showing the capability of t=
he new=20
dm-mpath]

Random Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 939752 | 3670.1MB/s |
8k   | 741462 | 5792.7MB/s |
16k | 399285 | 6238.9MB/s |
32k | 196490 | 6140.4MB/s |
64k | 100325 | 6270.4MB/s |

Sequential Read:
BS   | IOPS     | BW
------+------------+-------------------+
4k   | 926222 | 3618.6MB/s |
8k   | 750125 | 5860.4MB/s |
16k | 397770 | 6215.2MB/s |
32k | 200130 | 6254.8MB/s |=20
64k | 100397 | 6274.9MB/s |

Random Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 251938 | 984.14MB/s |
8k   | 226712 | 1771.2MB/s |
16k | 180739 | 2824.5MB/s |
32k | 133316 | 4166.2MB/s |
64k |  98738  | 6171.2MB/s |

Sequential Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 134660 | 538643KB/s |
8k   | 131585 | 1028.9MB/s |
16k | 131030 | 2047.4MB/s |
32k | 126987 | 3968.4MB/s |
64k |  98882  | 6180.2MB/s |

Emulex 16GBit FC HBA NetApp EF560 Array w/ DM SQ this patchset:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
Random Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 101860 | 407443KB/s |
8k   | 100242 | 801940KB/s |
16k |   99774 | 1558.1MB/s |
32k | 134304 | 4197.8MB/s |
64k | 100126 | 6257.1MB/s |

Sequential Read:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 285585 | 1115.6MB/s |=20
8k   | 313619 | 2450.2MB/s |
16k | 190696 | 2979.7MB/s |
32k | 200569 | 6267.9MB/s |
64k | 100366 | 6272.1MB/s |

Random Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   |  98434  | 393738KB/s |
8k   |  97286  | 778294KB/s |=20
16k |  97623  | 1525.4MB/s |
32k | 126999 | 3968.8MB/s |
64k |  94309  | 5894.4MB/s |

Sequential Write:
BS   | IOPS     | BW                |
------+------------+-------------------+
4k   | 330066 | 1289.4MB/s |
8k   | 452792 | 3537.5MB/s |
16k | 334481 | 5226.3MB/s |
32k | 186916 | 5841.2MB/s |
64k |  88698  | 5543.7MB/s |

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
